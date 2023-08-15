import { HttpStatus } from '@nestjs/common';

import { HttpError } from './http-error';

export class ConflictError extends HttpError {
	constructor() {
		super(HttpStatus.CONFLICT, 'Conflict');
	}
}
