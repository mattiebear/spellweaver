import { IsString } from 'class-validator';

import { IsUserId } from '../common/lib/validation';

export class User {
	@IsUserId()
	id: string;

	@IsString()
	imageUrl: string;

	@IsString()
	username: string;
}
