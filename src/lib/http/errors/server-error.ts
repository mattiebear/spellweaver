import { HttpStatus } from '../http-status';
import { HttpError } from './http-error';

export class ServerError extends HttpError {
	constructor(message = '') {
		super(HttpStatus.ServerError, message);
	}
}
