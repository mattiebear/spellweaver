import { Connection } from '../entity';
import { db } from './db';

export const connectionRepository = db.getRepository(Connection);
