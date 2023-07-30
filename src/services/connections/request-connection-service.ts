import clerk from '@clerk/clerk-sdk-node';

import { Connection } from '../../entity';
import { BadRequestError, HttpError } from '../../lib/http';

type ConnectionCreateServiceParams = {
	username: string;
};

export class RequestConnectionService {
	private connection: Connection;
	private readonly username: string;

	constructor({ username }: ConnectionCreateServiceParams) {
		this.username = username;
	}

	async run() {
		this.validateParams();
		await this.fetchUserDetails();
		// await this.fetchExistingRequest();
		// await this.createConnections();
	}

	result() {
		return {};
	}

	private validateParams() {
		if (!this.username) {
			throw new BadRequestError().add('username', 'required');
		}
	}

	private async fetchUserDetails() {
		const users = await clerk.users.getUserList({
			username: [this.username],
		});

		if (!users.length) {
		}

		console.log({ users });
	}
}
