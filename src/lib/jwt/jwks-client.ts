import createClient from 'jwks-rsa';

import { ENV } from '../application/env';

export const jwksClient = createClient({
	jwksUri: ENV.fetch('JWKS_URI'),
});
