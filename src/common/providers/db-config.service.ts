import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModuleOptions, TypeOrmOptionsFactory } from '@nestjs/typeorm';

import { ConnectionUser } from '../../connections/connection-user.entity';
import { Connection } from '../../connections/connection.entity';
import { Map } from '../../maps/map.entity';

@Injectable()
export class DBConfigService implements TypeOrmOptionsFactory {
	constructor(private configService: ConfigService) {}

	createTypeOrmOptions(): TypeOrmModuleOptions {
		return {
			type: 'postgres',
			url: this.configService.get<string>('DATABASE_URL'),
			entities: [Connection, ConnectionUser, Map],
			// TODO: Only sync local dev
			synchronize: true,
			logging: true,
			uuidExtension: 'pgcrypto',
		};
	}
}
