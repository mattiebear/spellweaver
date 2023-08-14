import {
	Body,
	Controller,
	Delete,
	Get,
	HttpCode,
	HttpStatus,
	Param,
	Patch,
	Post,
} from '@nestjs/common';

import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../users/user.entity';
import { ConnectionsService } from './connections.service';
import { CreateConnectionDto } from './dto/create-connection.dto';
import { UpdateConnectionDto } from './dto/update-connection.dto';

@Controller('connections')
export class ConnectionsController {
	constructor(private connectionsService: ConnectionsService) {}

	@Get()
	getList(@CurrentUser() user: User) {
		return this.connectionsService.findAll(user.id);
	}

	@Post()
	create(
		@CurrentUser() user: User,
		@Body() createConnectionDto: CreateConnectionDto
	) {
		return this.connectionsService.create(createConnectionDto, user);
	}

	@Patch(':id')
	async update(
		@CurrentUser() user: User,
		@Param('id') id: string,
		@Body() updateConnectionDto: UpdateConnectionDto
	) {
		const connection = await this.connectionsService.findOne(id);

		return this.connectionsService.update(connection, updateConnectionDto);
	}

	@Delete(':id')
	@HttpCode(HttpStatus.NO_CONTENT)
	async destroy(@CurrentUser() user: User, @Param('id') id: string) {
		const connection = await this.connectionsService.findOne(id);

		return this.connectionsService.destroy(connection);
	}
}
