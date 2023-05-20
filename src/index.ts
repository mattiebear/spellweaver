import Koa from 'koa';
import Router from '@koa/router';

const app = new Koa();
const router = new Router();

router.get('/', (ctx) => {
  ctx.body = { succes: true };
});

app.use(router.routes()).use(router.allowedMethods());

app.listen(3000);
