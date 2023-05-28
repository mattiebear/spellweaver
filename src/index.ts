import Router from '@koa/router';
import Koa from 'koa';

import { allowedOrigins } from './middleware/cors';
import { jwtAuthentication } from './middleware/jwt-auth';

console.log('database password', process.env.DATABASE_PASSWORD);

const app = new Koa();
const router = new Router();

router.get('/ping', (ctx) => {
	ctx.body = { status: 'pong' };
});

app.use(allowedOrigins);
app.use(jwtAuthentication);

app.use(router.routes());
app.use(router.allowedMethods());

app.listen(3000);
console.log('Listening on port 3000');
