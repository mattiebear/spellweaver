import { createAuthorize } from '../lib/auth';
import { mapPolicy } from './policies/map-policy';

export const authorize = createAuthorize({ policies: [mapPolicy] });
