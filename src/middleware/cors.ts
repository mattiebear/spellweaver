import cors from '@koa/cors';

// TODO: Add specific origin
export const allowedOrigins = 	cors({
	origin: '*',
})
