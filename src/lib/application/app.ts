import Koa from 'koa';
import bodyParser from 'koa-bodyparser';

import { allowedOrigins } from '../../middleware/cors';
import { handleHttpError } from '../../middleware/handle-http-error';
import { jwtAuthentication } from '../../middleware/jwt-auth';
import { router } from '../../routes';

const app = new Koa();

app
	.use(handleHttpError)
	.use(bodyParser())
	.use(allowedOrigins)
	.use(jwtAuthentication)
	.use(router.routes())
	.use(router.allowedMethods());

export { app };
