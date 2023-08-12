import { IsString } from 'class-validator';
import { pick } from 'ramda';

import { IsUserId } from '../common/lib/validation';

export class User {
	constructor(data: Partial<User> = {}) {
		Object.assign(this, pick(['id', 'imageUrl', 'username'], data));
	}

	@IsUserId()
	id: string;

	@IsString()
	imageUrl: string;

	@IsString()
	username: string;
}
