import clerk, { User as AuthUser } from '@clerk/clerk-sdk-node';
import { Injectable } from '@nestjs/common';

import { User } from './user.entity';

@Injectable()
export class UsersService {
	findAll(...options: Parameters<typeof clerk.users.getUserList>) {
		return clerk.users.getUserList(...options);
	}

	async associate<T>(
		records: T[],
		{ fKey = 'userId', recordKey = 'user' } = {}
	) {
		const ids = records.map((record) => record[fKey]);
		const users = await this.findAll({ userId: ids });

		return records.map((record) => {
			const user = users.find((user) => user.id === record[fKey]);

			if (!user) {
				return record;
			}

			Object.assign(record, { [recordKey]: this.toSafeUser(user) });

			return record;
		});
	}

	toSafeUser({ id, imageUrl, username }: AuthUser) {
		const user = new User();

		Object.assign(user, { id, imageUrl, username });

		return user;
	}
}
