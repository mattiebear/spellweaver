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

import { AclService } from '../acl/acl.service';
import { Action } from '../acl/action';
import { User as GetUser } from '../common/decorators/user.decorator';
import { User } from '../users/user.entity';
import { CreateMapDto } from './dto/create-map.dto';
import { UpdateMapDto } from './dto/update-map.dto';
import { MapsService } from './maps.service';

@Controller('maps')
export class MapsController {
	constructor(
		private mapsService: MapsService,
		private aclService: AclService
	) {}

	@Get()
	getList(@GetUser() user: User) {
		this.aclService.verifyList(user, 'Map');

		return this.mapsService.findAll(user.id);
	}

	@Get(':id')
	async getDetail(@Param('id') id: string, @GetUser() user: User) {
		const map = await this.mapsService.findOne(id);

		this.aclService.verify(map, user, Action.Read);

		return map;
	}

	@Post()
	create(@Body() createMapDto: CreateMapDto, @GetUser() user: User) {
		return this.mapsService.create(createMapDto, user);
	}

	@Patch(':id')
	async update(
		@Param('id') id: string,
		@Body() updateMapDto: UpdateMapDto,
		@GetUser() user: User
	) {
		const map = await this.mapsService.findOne(id);

		this.aclService.verify(map, user, Action.Update);

		return this.mapsService.update(map, updateMapDto);
	}

	@Delete(':id')
	@HttpCode(HttpStatus.NO_CONTENT)
	async destroy(@Param('id') id: string, @GetUser() user: User) {
		const map = await this.mapsService.findOne(id);

		this.aclService.verify(map, user, Action.Delete);

		return this.mapsService.destroy(map);
	}
}
