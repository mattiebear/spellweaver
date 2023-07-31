import { HttpError } from '../errors/http-error';
import { HttpStatus } from '../http-status';

it('sets expose to true when a localized error is added', () => {
	const error = new HttpError(HttpStatus.UnprocessableContent);

	error.add('name', 'required');

	expect(error.expose).toBe(true);
});

it('formats the error as JSON', () => {
	const error = new HttpError(HttpStatus.UnprocessableContent);

	error.add('name', 'required');

	expect(error.toJSON()).toEqual({
		data: [
			{
				location: 'name',
				code: 'required',
			},
		],
	});
});

it('includes a message if provided', () => {
	const error = new HttpError(HttpStatus.UnprocessableContent, 'invalid data');

	error.add('name', 'required');

	expect(error.toJSON()).toEqual({
		message: 'invalid data',
		data: [
			{
				location: 'name',
				code: 'required',
			},
		],
	});
});
