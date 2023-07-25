import { Map } from '../entity';
import { db } from './db';

export const mapRepository = db.getRepository(Map);
