import { Middleware } from 'koa';

import { HttpError } from '../lib/http';

export const handleHttpError: Middleware = async (ctx, next) => {
	try {
		await next();
	} catch (err) {
		if (err instanceof HttpError) {
			ctx.status = err.status;

			if (err.expose) {
				ctx.body = err.toJSON();
			}
		} else {
			throw err;
		}
	}
};
