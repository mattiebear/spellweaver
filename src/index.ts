import Koa from 'koa';
import Router from '@koa/router';
import jwksClient from 'jwks-rsa';
import jwt from 'jsonwebtoken';

class HttpError extends Error {
  status: number;
  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

const client = jwksClient({
  jwksUri: 'https://ideal-jackal-78.clerk.accounts.dev/.well-known/jwks.json',
});

const app = new Koa();
const router = new Router();

router.get('/healthz', (ctx) => {
  ctx.body = { succes: true };
});

app.use(async (ctx, next) => {
  const token = ctx.request.headers.authorization?.split(' ')[1];

  if (!token) {
    throw new HttpError('No token provided', 401);
  }

  const key = await client.getSigningKey('ins_2Q1sqhNI0Z1N4tLkIvObwQWdb7E');

  const signingKey = key.getPublicKey();

  if (!signingKey) {
    throw new HttpError('Signing key error', 500);
  }

  try {
    jwt.verify(token, signingKey);
  } catch {
    throw new HttpError('Not autenticated', 401);
  }

  await next();
});

app.use(router.routes());
app.use(router.allowedMethods());

app.listen(3000);
console.log('Listening on port 3000');
