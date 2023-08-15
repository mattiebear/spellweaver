import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { User } from '../users/user.entity';
import { CreateMapDto } from './dto/create-map.dto';
import { UpdateMapDto } from './dto/update-map.dto';
import { Map } from './map.entity';

@Injectable()
export class MapsService {
	constructor(
		@InjectRepository(Map)
		private mapsRepository: Repository<Map>
	) {}

	findAll(user: User): Promise<Map[]> {
		return this.mapsRepository.findBy({ userId: user.id });
	}

	async findOne(user: User, id: string): Promise<Map> {
		const map = await this.mapsRepository.findOneBy({ id, userId: user.id });

		if (!map) {
			throw new NotFoundException();
		}

		return map;
	}

	create(user: User, dto: CreateMapDto): Promise<Map> {
		const map = new Map();

		Object.assign(map, dto, {
			userId: user.id,
			atlas: { version: '1', data: [] },
		});

		return this.mapsRepository.save(map);
	}

	async update(user: User, id: string, dto: UpdateMapDto) {
		const map = await this.findOne(user, id);

		Object.assign(map, dto);

		return this.mapsRepository.save(map);
	}

	async destroy(user: User, id: string) {
		const map = await this.findOne(user, id);

		return this.mapsRepository.remove(map);
	}
}
