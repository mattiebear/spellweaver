import 'reflect-metadata';

import { DataSource } from 'typeorm';

import { ENV } from '../lib/application/env';
import { Scene } from '../models/scene';

export const AppDataSource = new DataSource({
	type: 'postgres',
	url: ENV.fetch('DATABASE_URL'),
	entities: [Scene],
	synchronize: true,
	logging: ENV.isDevelopment(),
	uuidExtension: 'pgcrypto',
});
