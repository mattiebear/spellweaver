import createClient from 'jwks-rsa';

import { ENV } from '../application';

export const jwksClient = createClient({
	jwksUri: ENV.fetch('JWKS_URI'),
});
