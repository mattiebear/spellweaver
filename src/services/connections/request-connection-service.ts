import clerk, { User } from '@clerk/clerk-sdk-node';

import { db } from '../../db';
import { connectionRepository } from '../../db/connection-repositoy';
import { Connection, ConnectionStatus } from '../../entity';
import {
	BadRequestError,
	ConflictError,
	ErrorCode,
	NotFoundError,
} from '../../lib/http';
import { validate } from '../../lib/validation/validate';

type ConnectionCreateServiceParams = {
	userId: string;
	username: string;
};

export class RequestConnectionService {
	private readonly userId: string;
	private readonly username: string;

	private connection: Connection;
	private recipient: User;

	constructor({ userId, username }: ConnectionCreateServiceParams) {
		this.userId = userId;
		this.username = username;
	}

	async run() {
		this.validateParams();
		await this.fetchUserDetails();
		await this.fetchExistingRequest();
		await this.createConnections();
	}

	result() {
		return this.connection;
	}

	private validateParams() {
		if (!this.username) {
			throw new BadRequestError().add('username', ErrorCode.Required);
		}
	}

	private async fetchUserDetails() {
		const users = await clerk.users.getUserList({
			username: [this.username],
		});

		if (!users.length) {
			throw new NotFoundError().add('username', ErrorCode.NotFound);
		}

		this.recipient = users[0];
	}

	private async fetchExistingRequest() {
		const connection = await connectionRepository.findOneBy({
			userId: this.userId,
			connectedUserId: this.recipient.id,
		});

		if (connection) {
			throw new ConflictError().add('connection', ErrorCode.AlreadyExists);
		}
	}

	private async createConnections() {
		const userConnection = new Connection();
		userConnection.userId = this.userId;
		userConnection.connectedUserId = this.recipient.id;
		userConnection.status = ConnectionStatus.AwaitingResponse;

		const recipientConnection = new Connection();
		recipientConnection.userId = this.recipient.id;
		recipientConnection.connectedUserId = this.userId;
		recipientConnection.status = ConnectionStatus.PendingAcceptance;

		await validate(userConnection);
		await validate(recipientConnection);

		await db.transaction(async (manager) => {
			await manager.save(recipientConnection);
			this.connection = await manager.save(userConnection);
		});
	}
}
