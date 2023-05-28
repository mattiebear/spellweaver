import createClient from 'jwks-rsa';

export const client = createClient({
	jwksUri: process.env.JWKS_URI,
});
