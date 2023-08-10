declare global {
	namespace NodeJS {
		interface ProcessEnv {
			CLERK_SECRET_KEY: string;
			DATABASE_URL: string;
			JWKS_URI: string;
			NODE_ENV: 'development' | 'production';
			WEB_CLIENT_HOST: string;
		}
	}
}
