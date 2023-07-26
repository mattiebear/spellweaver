import { getStatusMessage } from './http-status';

export class HttpError extends Error {
	status: number;
	constructor(status: number, message = getStatusMessage(status)) {
		super(message);
		this.status = status;
	}
}
