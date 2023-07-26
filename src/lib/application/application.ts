import path from 'node:path';

export class Application {
	public static root() {
		return path.resolve(__dirname, '../../..');
	}
}
