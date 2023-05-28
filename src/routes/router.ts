import Router from '@koa/router';

import { router as mapsRouter } from './maps';

const router = new Router();

router.get('/ping', (ctx) => {
	ctx.body = { status: 'pong' };
});

router.use('/maps', mapsRouter.routes(), mapsRouter.allowedMethods());

export { router };
