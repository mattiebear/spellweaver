import Router from '@koa/router';

const router = new Router();

router.get('/ping', (ctx) => {
	ctx.body = { status: 'pong' };
});

export { router };
