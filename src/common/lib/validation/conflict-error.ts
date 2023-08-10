import { HttpStatus } from '@nestjs/common';

import { ValidationError } from './validation-error';

export class ConflictError extends ValidationError {
	constructor() {
		super(HttpStatus.CONFLICT, 'Conflict');
	}
}
