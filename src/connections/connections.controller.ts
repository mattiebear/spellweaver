import {
	Body,
	Controller,
	Delete,
	Get,
	Param,
	Patch,
	Post,
} from '@nestjs/common';

import { AclService } from '../acl/acl.service';
import { Action } from '../acl/action';
import { User as GetUser } from '../common/decorators/user.decorator';
import { User } from '../users/user.entity';
import { ConnectionsService } from './connections.service';
import { CreateConnectionDto } from './dto/create-connection.dto';
import { UpdateConnectionDto } from './dto/update-connection.dto';

@Controller('connections')
export class ConnectionsController {
	constructor(
		private connectionsService: ConnectionsService,
		private aclService: AclService
	) {}

	@Get()
	getList(@GetUser() user: User) {
		this.aclService.verifyList(user, 'Connection');
		return this.connectionsService.findAll(user.id);
	}

	@Post()
	create(
		@Body() createConnectionDto: CreateConnectionDto,
		@GetUser() user: User
	) {
		this.aclService.verify('Connection', user, Action.Create);
		return this.connectionsService.create(createConnectionDto, user);
	}

	@Patch(':id')
	async update(
		@Param('id') id: string,
		@Body() updateConnectionDto: UpdateConnectionDto,
		@GetUser() user: User
	) {
		const connection = await this.connectionsService.findOne(id);

		// TODO: need to fix this
		// this.aclService.verify(connection, user, Action.Update);

		return this.connectionsService.update(connection, updateConnectionDto);
	}

	@Delete(':id')
	async destroy(@Param('id') id: string, @GetUser() user: User) {
		const connection = await this.connectionsService.findOne(id);

		// TODO: need to fix this
		// this.aclService.verify(connection, user, Action.Delete);

		return this.connectionsService.destroy(connection);
	}
}
