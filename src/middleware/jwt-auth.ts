import jwt from 'jsonwebtoken';
import { Middleware, ParameterizedContext } from 'koa';

import { HttpError } from '../lib/error';
import { jwksClient } from '../lib/jwt/jwks-client';

// TODO: Verify issuer and expirations
interface DecodedToken {
	azp: string;
	exp: number;
	iat: number;
	iss: string;
	nbf: number;
	sid: string;
	sub: string;
}

const getTokenFromHeader = (ctx: ParameterizedContext) => {
	const authorization = ctx.request.headers.authorization;

	if (!authorization) {
		throw new HttpError('No token provided', 401);
	}

	const [type, token] = authorization.split(' ');

	if (type !== 'Bearer') {
		throw new HttpError('Invalid token type', 401);
	}

	return token;
};

const getSigningKey = async (token: string) => {
	const decoded = jwt.decode(token, { complete: true });

	const keyId = decoded?.header?.kid;

	if (!keyId) {
		throw new HttpError('Invalid token', 401);
	}

	const key = await jwksClient.getSigningKey(keyId);

	const signingKey = key.getPublicKey();

	if (!signingKey) {
		throw new HttpError('Signing key error', 500);
	}

	return signingKey;
};

const verifyToken = (token: string, signingKey: string) => {
	try {
		return jwt.verify(token, signingKey) as DecodedToken;
	} catch {
		throw new HttpError('Not autenticated', 401);
	}
};

export const jwtAuthentication: Middleware = async (ctx, next) => {
	const token = getTokenFromHeader(ctx);
	const signingKey = await getSigningKey(token);
	const decoded = verifyToken(token, signingKey);

	ctx.state.userId = decoded.sub;

	await next();
};
