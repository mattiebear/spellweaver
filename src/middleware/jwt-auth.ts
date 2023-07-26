import jwt from 'jsonwebtoken';
import { Middleware, ParameterizedContext } from 'koa';

import { HttpError, HttpStatus } from '../lib/http';
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
		throw new HttpError(HttpStatus.Unauthorized, 'No token provided');
	}

	const [type, token] = authorization.split(' ');

	if (type !== 'Bearer') {
		throw new HttpError(HttpStatus.Unauthorized, 'Invalid token type');
	}

	return token;
};

const getSigningKey = async (token: string) => {
	const decoded = jwt.decode(token, { complete: true });

	const keyId = decoded?.header?.kid;

	if (!keyId) {
		throw new HttpError(HttpStatus.Unauthorized, 'Invalid token');
	}

	const key = await jwksClient.getSigningKey(keyId);

	const signingKey = key.getPublicKey();

	if (!signingKey) {
		throw new HttpError(HttpStatus.ServerError, 'Signing key error');
	}

	return signingKey;
};

const verifyToken = (token: string, signingKey: string) => {
	try {
		return jwt.verify(token, signingKey) as DecodedToken;
	} catch {
		throw new HttpError(HttpStatus.Unauthorized, 'Not authenticated');
	}
};

export const jwtAuthentication: Middleware = async (ctx, next) => {
	const token = getTokenFromHeader(ctx);
	const signingKey = await getSigningKey(token);
	const decoded = verifyToken(token, signingKey);

	ctx.state.userId = decoded.sub;

	await next();
};
