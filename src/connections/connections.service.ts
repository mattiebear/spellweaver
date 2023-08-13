import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';

import { BadRequestError } from '../common/lib/validation/bad-request-error';
import { ConflictError } from '../common/lib/validation/conflict-error';
import { ErrorCode } from '../common/lib/validation/error-code';
import { NotFoundError } from '../common/lib/validation/not-found-error';
import { User } from '../users/user.entity';
import { UsersService } from '../users/users.service';
import { ConnectionRole, ConnectionUser } from './connection-user.entity';
import { Connection } from './connection.entity';
import { CreateConnectionDto } from './dto/create-connection.dto';
import { UpdateConnectionDto } from './dto/update-connection.dto';

@Injectable()
export class ConnectionsService {
	constructor(
		private dataSource: DataSource,
		@InjectRepository(Connection)
		private connectionRepository: Repository<Connection>,
		@Inject(UsersService) private usersService: UsersService
	) {}

	async findAll(userId: string) {
		const connections = await this.getUserConnections(userId);

		// TODO: Find a better way to do this
		const userIds = connections.flatMap((connection) => {
			return connection.connectionUsers.map(
				(connectionUser) => connectionUser.userId
			);
		});

		const usersData = await this.usersService.findAll({ userId: userIds });
		const users = usersData.map((data) => new User(data));

		connections.forEach((connection) => {
			connection.connectionUsers.forEach((connectionUser) => {
				const user = users.find((user) => user.id === connectionUser.userId);
				connectionUser.user = user;
			});
		});

		return connections;
	}

	async findOne(id: string): Promise<Connection | null> {
		return this.connectionRepository.findOneBy({ id });
	}

	async create(dto: CreateConnectionDto, user: User) {
		if (!dto.username) {
			throw new BadRequestError()
				.add('username', ErrorCode.Required, 'Username is required')
				.toException();
		}

		const users = await this.usersService.findAll({
			username: [dto.username],
		});

		if (!users.length) {
			throw new NotFoundError()
				.add('username', ErrorCode.NotFound, 'No user found with that name')
				.toException();
		}

		const recipient = users[0];

		if (user.id === recipient.id) {
			throw new ConflictError()
				.add('username', ErrorCode.Invalid, 'Cannot send a request to yourself')
				.toException();
		}

		const currentConnections = await this.getUserConnections(user.id);

		if (
			currentConnections.some((connection) => {
				return (
					connection.connectionUsers.some((conn) => conn.userId === user.id) &&
					connection.connectionUsers.some(
						(conn) => conn.userId === recipient.id
					)
				);
			})
		) {
			throw new ConflictError()
				.add('connection', ErrorCode.AlreadyExists, 'Request already sent')
				.toException();
		}

		const queryRunner = this.dataSource.createQueryRunner();

		await queryRunner.connect();
		await queryRunner.startTransaction();

		let connection: Connection;

		try {
			connection = await queryRunner.manager.save(new Connection());

			const recipientConn = new ConnectionUser();
			recipientConn.connection = connection;
			recipientConn.role = ConnectionRole.Recipient;
			recipientConn.userId = recipient.id;
			await queryRunner.manager.save(recipientConn);

			const requesterConn = new ConnectionUser();
			requesterConn.connection = connection;
			requesterConn.role = ConnectionRole.Requester;
			requesterConn.userId = user.id;
			await queryRunner.manager.save(requesterConn);

			await queryRunner.commitTransaction();
		} catch (err) {
			await queryRunner.rollbackTransaction();
		} finally {
			await queryRunner.release();
		}

		return connection;
	}

	async update(connection: Connection, dto: UpdateConnectionDto) {
		Object.assign(connection, dto);

		return this.connectionRepository.save(connection);
	}

	async destroy(connection: Connection) {
		await this.dataSource
			.createQueryBuilder()
			.delete()
			.from(ConnectionUser)
			.where('connectionId = :id', { id: connection.id })
			.execute();

		return this.connectionRepository.remove(connection, {});
	}

	private getUserConnections(userId: string) {
		return this.dataSource
			.getRepository(Connection)
			.createQueryBuilder('connection')
			.leftJoinAndSelect('connection.connectionUsers', 'connUsers')
			.where((builder) => {
				const subQuery = builder
					.subQuery()
					.select('connectionUser.connectionId')
					.from(ConnectionUser, 'connectionUser')
					.where('connectionUser.userId = :userId')
					.getQuery();

				return 'connection.id IN ' + subQuery;
			})
			.setParameter('userId', userId)
			.getMany();
	}
}
