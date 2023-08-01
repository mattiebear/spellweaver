import clerk, { User as AuthUser } from '@clerk/clerk-sdk-node';
import { map, pick, prop } from 'ramda';

import { User } from '../types/user';

export const toSafeUser = (user: AuthUser): User =>
	pick(['id', 'profileImageUrl', 'username'])(user) as User;

export const associateWithUser = async <T extends { userId: string }>(
	records: T[]
) => {
	const ids = map(prop('userId'), records) as string[];
	const users = await clerk.users.getUserList({
		userId: ids,
	});

	return records.map((record) => {
		const user = users.find((user) => user.id === record.userId);

		if (!user) {
			return record;
		}

		Object.assign(record, { user: toSafeUser(user) });

		return record;
	});
};
