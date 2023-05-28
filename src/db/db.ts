import 'reflect-metadata';

import { DataSource } from 'typeorm';

import { ENV } from '../lib/application/env';
import { Map } from '../models/map';

export const db = new DataSource({
	type: 'postgres',
	url: ENV.fetch('DATABASE_URL'),
	entities: [Map],
	synchronize: true,
	logging: ENV.isDevelopment(),
	uuidExtension: 'pgcrypto',
});
