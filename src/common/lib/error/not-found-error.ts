import { HttpStatus } from '@nestjs/common';

import { HttpError } from './http-error';

export class NotFoundError extends HttpError {
	constructor() {
		super(HttpStatus.NOT_FOUND, 'Not found');
	}
}
