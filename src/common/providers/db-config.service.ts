import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModuleOptions, TypeOrmOptionsFactory } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';

import { ConnectionUser } from '../../connections/connection-user.entity';
import { Connection } from '../../connections/connection.entity';
import { Map } from '../../maps/map.entity';
import { SessionUser } from '../../sessions/session-user.entity';
import { Session } from '../../sessions/session.entity';

@Injectable()
export class DBConfigService implements TypeOrmOptionsFactory {
	constructor(private configService: ConfigService) {}

	createTypeOrmOptions(): TypeOrmModuleOptions {
		return {
			type: 'postgres',
			url: this.configService.get<string>('DATABASE_URL'),
			entities: [Connection, ConnectionUser, Map, Session, SessionUser],
			// TODO: Only sync local dev
			synchronize: true,
			logging: true,
			uuidExtension: 'pgcrypto',
		};
	}
}

// TODO: Figure out how to make this work
export const connectionSource = new DataSource({
	type: 'postgres',
	url: 'postgresql://hexx_manager:Qi5n!32r!bcF@localhost:5432/hexx_development',
	entities: [Connection, ConnectionUser, Map, Session, SessionUser],
	synchronize: true,
	logging: true,
	uuidExtension: 'pgcrypto',
});
