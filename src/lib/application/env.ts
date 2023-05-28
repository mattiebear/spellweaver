import dotenv from 'dotenv';
import fs from 'node:fs';
import path from 'node:path';

export class ENV {
	private static _instance: ENV;

	private constructor() {
		this.configEnv();
	}

	private configEnv() {
		const files = [
			`.env.${this.env}.local`,
			`.env.${this.env}`,
			'.env.local',
			'.env',
		];

		for (const file of files) {
			if (this.loadConfigIfExists(file)) {
				return;
			}
		}
	}

	private loadConfigIfExists(file: string) {
		// TODO: Get root from application class
		const filePath = path.resolve(process.cwd(), file);

		const fileExists = fs.existsSync(filePath);

		if (fileExists) {
			dotenv.config({ path: filePath });

			return true;
		}
	}

	get env() {
		return process.env.NODE_ENV || 'development';
	}

	get(key: string) {
		return process.env[key];
	}

	// Singleton static methods

	public static getInstance() {
		if (!ENV._instance) {
			ENV._instance = new ENV();
		}

		return ENV._instance;
	}

	public static config() {
		return ENV.getInstance();
	}

	public static isDevelopment() {
		return ENV.getInstance().env === 'development';
	}

	public static isProduction() {
		return ENV.getInstance().env === 'production';
	}

	public static get(key: string) {
		return ENV.getInstance().get(key);
	}

	public static fetch(key: string) {
		const value = ENV.get(key);

		if (!value) {
			throw new Error(`Missing environment variable: ${key}`);
		}

		return value;
	}
}
