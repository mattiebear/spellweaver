import { Not } from 'typeorm';

import { db } from '../../db';
import { connectionRepository } from '../../db/connection-repositoy';
import { Connection, ConnectionStatus } from '../../entity';
import {
	BadRequestError,
	ErrorCode,
	NotFoundError,
	ServerError,
} from '../../lib/http';

type UpdateConnectionServiceParams = {
	connection: Connection;
	status: ConnectionStatus;
};

export class UpdateConnectionService {
	private connection: Connection;
	private readonly status: ConnectionStatus;

	private related: Connection;

	constructor({ connection, status }: UpdateConnectionServiceParams) {
		this.connection = connection;
		this.status = status;
	}

	async run() {
		this.validateParams();
		await this.getRelatedConnection();
		await this.updateConnections();
	}

	result() {
		return this.connection;
	}

	private validateParams() {
		if (!this.status) {
			throw new BadRequestError().add('status', ErrorCode.Required);
		}
	}

	private async getRelatedConnection() {
		const related = await connectionRepository.findOneBy({
			userId: this.connection.connectedUserId,
			connectedUserId: this.connection.userId,
			status: Not(ConnectionStatus.Removed),
		});

		if (!related) {
			throw new NotFoundError().add('related', ErrorCode.NotFound);
		}

		this.related = related;
	}

	private async updateConnections() {
		this.connection.status = this.status;
		this.related.status = this.status;

		await db.transaction(async (manager) => {
			await manager.save(this.related);
			this.connection = await manager.save(this.connection);
		});
	}
}
