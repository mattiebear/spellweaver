import { HttpStatus } from '@nestjs/common';

type ErrorData = {
	code: string;
	location: string;
	message: string;
};

export class HttpError extends Error {
	private data: ErrorData[] = [];

	public status: number;

	constructor(
		status: number = HttpStatus.INTERNAL_SERVER_ERROR,
		message = 'Unknown error'
	) {
		super(message);
		this.status = status;
	}

	add(location: string, code: string, message: string) {
		this.data.push({ code, location, message });
		return this;
	}

	toJSON() {
		return {
			...(this.message && {
				message: this.message,
			}),
			data: this.data,
		};
	}
}
