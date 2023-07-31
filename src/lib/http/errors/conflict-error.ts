import { HttpStatus } from '../http-status';
import { HttpError } from './http-error';

export class ConflictError extends HttpError {
	constructor(message = '') {
		super(HttpStatus.Conflict, message);
	}
}
