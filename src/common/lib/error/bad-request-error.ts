import { HttpStatus } from '@nestjs/common';

import { HttpError } from './http-error';

export class BadRequestError extends HttpError {
	constructor() {
		super(HttpStatus.BAD_REQUEST, 'Bad request');
	}
}
