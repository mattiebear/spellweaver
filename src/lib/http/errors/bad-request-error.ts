import { HttpStatus } from '../http-status';
import { HttpError } from './http-error';

export class BadRequestError extends HttpError {
	constructor(message = '') {
		super(HttpStatus.BadRequest, message);
	}
}
