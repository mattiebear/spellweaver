import { DataSource } from 'typeorm';

import { Map } from '../entity';
import { ENV } from '../lib/application';

export const db = new DataSource({
	type: 'postgres',
	url: ENV.fetch('DATABASE_URL'),
	entities: [Map],
	synchronize: true,
	logging: ENV.isDevelopment(),
	uuidExtension: 'pgcrypto',
});
