import { validate as baseValidate } from 'class-validator';

import { HttpError, HttpStatus } from '../http';

export const validate = async (record: any) => {
	const errors = await baseValidate(record);

	if (errors.length) {
		const error = new HttpError(HttpStatus.UnprocessableContent);

		for (const err of errors) {
			if (err.constraints) {
				for (const [, message] of Object.entries(err.constraints)) {
					error.add(err.property, message);
				}
			}
		}

		throw error;
	}
};
