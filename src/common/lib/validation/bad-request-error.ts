import { HttpStatus } from '@nestjs/common';

import { ValidationError } from './validation-error';

export class BadRequestError extends ValidationError {
	constructor() {
		super(HttpStatus.BAD_REQUEST, 'Bad request');
	}
}
