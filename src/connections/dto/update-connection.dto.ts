import { IsIn, IsString } from 'class-validator';

import { ConnectionStatus } from '../connection.entity';

export class UpdateConnectionDto {
	@IsString()
	@IsIn([
		ConnectionStatus.Rejected,
		ConnectionStatus.Accepted,
		ConnectionStatus.Removed,
	])
	status: string;
}
