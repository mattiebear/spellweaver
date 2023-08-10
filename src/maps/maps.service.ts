import { Injectable } from '@nestjs/common';
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

	findAll(userId: string): Promise<Map[]> {
		return this.mapsRepository.findBy({ userId });
	}

	findOne(id: string): Promise<Map | null> {
		return this.mapsRepository.findOneBy({ id });
	}

	create(dto: CreateMapDto, user: User) {
		const map = new Map();

		Object.assign(map, {
			...dto,
			userId: user.id,
			atlas: { version: '1', data: [] },
		});

		return this.mapsRepository.save(map);
	}

	update(map: Map, dto: UpdateMapDto) {
		Object.assign(map, {
			...dto,
		});

		return this.mapsRepository.save(map);
	}

	destroy(map: Map) {
		return this.mapsRepository.remove(map);
	}
}
