import { ValidationError as BaseError } from 'class-validator';

import { ValidationError } from './validation-error';

export const exceptionFactory = (errors: BaseError[]) => {
	const error = new ValidationError();

	for (const err of errors) {
		if (err.constraints) {
			for (const [code, message] of Object.entries(err.constraints)) {
				error.add(err.property, code, message);
			}
		}
	}

	throw error.toException();
};
