export enum HttpStatus {
	OK = 200,
	Created = 201,
	Accepted = 202,
	NoContent = 204,
	Found = 302,
	BadRequest = 400,
	Unauthorized = 401,
	Forbidden = 403,
	NotFound = 404,
	ServerError = 500,
}

export const getStatusMessage = (status: HttpStatus) => {
	const text = Object.entries(HttpStatus).find(([, value]) => value === status);

	if (text) {
		return text[0].replaceAll(/([A-Z])/g, ' $1');
	}

	return 'An error occurred';
};
