import createClient from 'jwks-rsa';

import { Env } from '../application/env';

export const jwksClient = createClient({
	jwksUri: Env.fetch('JWKS_URI'),
});
