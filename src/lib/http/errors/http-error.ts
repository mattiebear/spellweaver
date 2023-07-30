type ErrorData = {
	code: string;
	location: string;
};

export class HttpError extends Error {
	private data: ErrorData[] = [];

	public expose = false;
	public status: number;

	constructor(status: number, message = '') {
		super(message);
		this.status = status;
	}

	add(location: string, code: string) {
		this.expose = true;
		this.data.push({ code, location });
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
