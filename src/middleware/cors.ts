import cors from '@koa/cors';

import { ENV } from '../lib/application/env';

export const allowedOrigins = cors({
	origin: ENV.fetch('WEB_CLIENT_HOST'),
});
