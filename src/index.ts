import Koa from 'koa';

import { AppDataSource } from './db/data-source';
import { allowedOrigins } from './middleware/cors';
import { jwtAuthentication } from './middleware/jwt-auth';
import { router } from './routes';

const app = new Koa();

app.use(allowedOrigins);
app.use(jwtAuthentication);

app.use(router.routes());
app.use(router.allowedMethods());

AppDataSource.initialize().then(() => {
	app.listen(3000);

	console.log('Listening on port 3000');
});
