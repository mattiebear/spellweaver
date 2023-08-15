import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';

import { BadRequestError } from '../common/lib/error/bad-request-error';
import { ConflictError } from '../common/lib/error/conflict-error';
import { ErrorCode } from '../common/lib/error/error-code';
import { NotFoundError } from '../common/lib/error/not-found-error';
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

	async findAll(user: User) {
		const connections = await this.getUserConnections(user);

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
				connectionUser.user = users.find(
					(user) => user.id === connectionUser.userId
				);
			});
		});

		return connections;
	}

	async findOne(user: User, id: string): Promise<Connection> {
		const connection = await this.connectionRepository.findOne({
			where: { id },
			relations: {
				connectionUsers: true,
			},
		});

		const isConnectionUser = connection?.connectionUsers.some(
			(cu) => cu.userId === user.id
		);

		if (!connection || !isConnectionUser) {
			throw new NotFoundException();
		}

		return connection;
	}

	async create(user: User, dto: CreateConnectionDto) {
		if (!dto.username) {
			throw new BadRequestError().add(
				'username',
				ErrorCode.Required,
				'Username is required'
			);
		}

		const users = await this.usersService.findAll({
			username: [dto.username],
		});

		if (!users.length) {
			throw new NotFoundError().add(
				'username',
				ErrorCode.NotFound,
				'No user found with that name'
			);
		}

		const recipient = users[0];

		if (user.id === recipient.id) {
			throw new ConflictError().add(
				'username',
				ErrorCode.Invalid,
				'Cannot send a request to yourself'
			);
		}

		const currentConnections = await this.getUserConnections(user);

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
			throw new ConflictError().add(
				'connection',
				ErrorCode.AlreadyExists,
				'Request already sent'
			);
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

	async update(user: User, id: string, dto: UpdateConnectionDto) {
		const connection = await this.findOne(user, id);

		Object.assign(connection, dto);

		return this.connectionRepository.save(connection);
	}

	async destroy(user: User, id: string) {
		const connection = await this.findOne(user, id);

		await this.dataSource
			.createQueryBuilder()
			.delete()
			.from(ConnectionUser)
			.where('connectionId = :id', { id: connection.id })
			.execute();

		return this.connectionRepository.remove(connection);
	}

	private getUserConnections(user: User) {
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
			.setParameter('userId', user.id)
			.getMany();
	}
}
