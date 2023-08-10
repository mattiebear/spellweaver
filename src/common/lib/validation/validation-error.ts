import { HttpException, HttpStatus } from '@nestjs/common';

type ErrorData = {
	code: string;
	location: string;
	message: string;
};

export class ValidationError extends Error {
	private data: ErrorData[] = [];

	public expose = false;
	public status: number;

	constructor(
		status: number = HttpStatus.UNPROCESSABLE_ENTITY,
		message = 'Unprocessable entity'
	) {
		super(message);
		this.status = status;
	}

	add(location: string, code: string, message: string) {
		this.expose = true;
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

	toException() {
		return new HttpException(this.toJSON(), this.status);
	}
}
