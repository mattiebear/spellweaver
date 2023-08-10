import { HttpStatus } from '@nestjs/common';

import { ValidationError } from './validation-error';

export class NotFoundError extends ValidationError {
	constructor() {
		super(HttpStatus.NOT_FOUND, 'Not found');
	}
}
