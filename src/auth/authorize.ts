import { createAuthorize } from '../lib/auth';
import { connectionPolicy } from './policies/connection-policy';
import { mapPolicy } from './policies/map-policy';

export const authorize = createAuthorize({
	policies: [connectionPolicy, mapPolicy],
});
