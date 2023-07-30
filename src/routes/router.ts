import Router from '@koa/router';

import { HttpError, HttpStatus } from '../lib/http';
import { router as connectionsRouter } from './connections';
import { router as mapsRouter } from './maps';

const router = new Router();

router.get('/ping', (ctx) => {
	ctx.body = { status: 'pong' };
});

router.get('/pong', () => {
	const error = new HttpError(HttpStatus.UnprocessableContent, 'No pong found');

	error.add('ping', 'pong');

	throw error;
});

router.use(
	'/connections',
	connectionsRouter.routes(),
	connectionsRouter.allowedMethods()
);

router.use('/maps', mapsRouter.routes(), mapsRouter.allowedMethods());

export { router };
