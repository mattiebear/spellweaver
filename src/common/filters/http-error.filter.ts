import { ArgumentsHost, Catch, ExceptionFilter } from '@nestjs/common';
import { Response } from 'express';

import { HttpError } from '../lib/error/http-error';

@Catch(HttpError)
export class HttpErrorFilter implements ExceptionFilter {
	catch(error: HttpError, host: ArgumentsHost) {
		const ctx = host.switchToHttp();
		const response = ctx.getResponse<Response>();

		response.status(error.status).json(error.toJSON());
	}
}
