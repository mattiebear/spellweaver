import { HttpStatus } from '../http-status';
import { HttpError } from './http-error';

export class UnprocessableError extends HttpError {
	constructor(message = '') {
		super(HttpStatus.UnprocessableContent, message);
	}
}
