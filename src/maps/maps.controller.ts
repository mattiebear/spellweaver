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
import { CreateMapDto } from './dto/create-map.dto';
import { UpdateMapDto } from './dto/update-map.dto';
import { MapsService } from './maps.service';

@Controller('maps')
export class MapsController {
	constructor(private mapsService: MapsService) {}

	@Get()
	getList(@CurrentUser() user: User) {
		return this.mapsService.findAll(user);
	}

	@Get(':id')
	async getDetail(@CurrentUser() user: User, @Param('id') id: string) {
		return await this.mapsService.findOne(user, id);
	}

	@Post()
	create(@CurrentUser() user: User, @Body() createMapDto: CreateMapDto) {
		return this.mapsService.create(user, createMapDto);
	}

	@Patch(':id')
	async update(
		@CurrentUser() user: User,
		@Param('id') id: string,
		@Body() updateMapDto: UpdateMapDto
	) {
		return this.mapsService.update(user, id, updateMapDto);
	}

	@Delete(':id')
	@HttpCode(HttpStatus.NO_CONTENT)
	async destroy(@CurrentUser() user: User, @Param('id') id: string) {
		return this.mapsService.destroy(user, id);
	}
}
