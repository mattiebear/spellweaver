import { ValidationError as BaseError } from 'class-validator';

import { HttpError } from '../error/http-error';

export const exceptionFactory = (errors: BaseError[]) => {
	const error = new HttpError();

	for (const err of errors) {
		if (err.constraints) {
			for (const [code, message] of Object.entries(err.constraints)) {
				error.add(err.property, code, message);
			}
		}
	}

	throw error;
};
