import { Map } from '../models/map';
import { db } from './db';

export const mapRepository = db.getRepository(Map);
