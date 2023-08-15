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
		return this.connectionsService.findAll(user);
	}

	@Post()
	create(
		@CurrentUser() user: User,
		@Body() createConnectionDto: CreateConnectionDto
	) {
		return this.connectionsService.create(user, createConnectionDto);
	}

	@Patch(':id')
	async update(
		@CurrentUser() user: User,
		@Param('id') id: string,
		@Body() updateConnectionDto: UpdateConnectionDto
	) {
		return this.connectionsService.update(user, id, updateConnectionDto);
	}

	@Delete(':id')
	@HttpCode(HttpStatus.NO_CONTENT)
	async destroy(@CurrentUser() user: User, @Param('id') id: string) {
		return this.connectionsService.destroy(user, id);
	}
}
