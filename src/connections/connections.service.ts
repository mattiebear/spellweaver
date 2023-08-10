import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Not, Repository } from 'typeorm';

import { BadRequestError } from '../common/lib/validation/bad-request-error';
import { ConflictError } from '../common/lib/validation/conflict-error';
import { ErrorCode } from '../common/lib/validation/error-code';
import { NotFoundError } from '../common/lib/validation/not-found-error';
import { User } from '../users/user.entity';
import { UsersService } from '../users/users.service';
import { Connection, ConnectionStatus } from './connection.entity';
import { CreateConnectionDto } from './dto/create-connection.dto';
import { UpdateConnectionDto } from './dto/update-connection.dto';

@Injectable()
export class ConnectionsService {
	constructor(
		@InjectRepository(Connection)
		private connectionRepository: Repository<Connection>,
		private dataSource: DataSource,
		@Inject(UsersService) private usersService: UsersService
	) {}

	async findAll(userId: string): Promise<Connection[]> {
		const connections = await this.connectionRepository.findBy({
			status: Not(ConnectionStatus.Rejected),
			userId,
		});

		return this.usersService.associate(connections, {
			fKey: 'connectedUserId',
			recordKey: 'connectedUser',
		});
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

		const existing = await this.connectionRepository.findOneBy({
			userId: user.id,
			connectedUserId: recipient.id,
		});

		if (existing) {
			throw new ConflictError()
				.add('connection', ErrorCode.AlreadyExists, 'Request already sent')
				.toException();
		}

		const userConnection = new Connection();
		userConnection.userId = user.id;
		userConnection.connectedUserId = recipient.id;
		userConnection.status = ConnectionStatus.AwaitingResponse;

		const recipientConnection = new Connection();
		recipientConnection.userId = recipient.id;
		recipientConnection.connectedUserId = user.id;
		recipientConnection.status = ConnectionStatus.PendingAcceptance;

		const queryRunner = this.dataSource.createQueryRunner();

		await queryRunner.connect();
		await queryRunner.startTransaction();

		let connection;

		try {
			connection = await queryRunner.manager.save(userConnection);
			await queryRunner.manager.save(recipientConnection);

			await queryRunner.commitTransaction();
		} catch (err) {
			await queryRunner.rollbackTransaction();
		} finally {
			await queryRunner.release();
		}

		return connection;
	}

	async update(connection: Connection, dto: UpdateConnectionDto) {
		const related = await this.connectionRepository.findOneBy({
			userId: connection.connectedUserId,
			connectedUserId: connection.userId,
			status: Not(ConnectionStatus.Removed),
		});

		if (!related) {
			throw new NotFoundError()
				.add('related', ErrorCode.NotFound, 'No corresponding request found')
				.toException();
		}

		Object.assign(connection, dto);
		Object.assign(related, dto);

		const queryRunner = this.dataSource.createQueryRunner();

		await queryRunner.connect();
		await queryRunner.startTransaction();

		try {
			await queryRunner.manager.save(connection);
			await queryRunner.manager.save(related);

			await queryRunner.commitTransaction();
		} catch (err) {
			await queryRunner.rollbackTransaction();
		} finally {
			await queryRunner.release();
		}

		return connection;
	}
}
