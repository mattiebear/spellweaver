import { DataSource } from 'typeorm';

import { Connection, Map } from '../entity';
import { ENV } from '../lib/application/env';

export const db = new DataSource({
	type: 'postgres',
	url: ENV.fetch('DATABASE_URL'),
	entities: [Connection, Map],
	synchronize: true,
	logging: ENV.isDevelopment(),
	uuidExtension: 'pgcrypto',
});
