import dotenv from 'dotenv';
import fs from 'node:fs'
import path from 'node:path'

export class Env {
	private static _instance: Env;

	private constructor() {
		this.configEnv()
	}

	get env() {
		return process.env.NODE_ENV || 'development';
	}

	static getInstance() {
		if (!Env._instance) {
			Env._instance = new Env();
		}

		return Env._instance;
	}

	static config() {
		return Env.getInstance();
	}

	private configEnv() {
		['.env', '.env.local', `.env.${this.env}`, `.env.${this.env}.local`].forEach((file) => {
			this.loadConfigIfExists(file);
		});
	}

	private loadConfigIfExists(file: string) {
		const filePath = path.resolve(__dirname, file);

		const fileExists = fs.existsSync(filePath);

		if (fileExists) {
			dotenv.config({ path: filePath });
		}
	}
}
