import Router from '@koa/router';

const router = new Router();

router.post('/', (ctx) => {
	console.log('body is', ctx.request.body);

	ctx.status = 200;
});

export { router };
