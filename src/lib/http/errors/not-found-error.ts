import { HttpStatus } from '../http-status';
import { HttpError } from './http-error';

export class NotFoundError extends HttpError {
	constructor(message = '') {
		super(HttpStatus.NotFound, message);
	}
}
