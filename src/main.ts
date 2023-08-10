import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';

import { AppModule } from './app.module';
import { exceptionFactory } from './common/lib/validation/exception.factory';

async function bootstrap() {
	const app = await NestFactory.create(AppModule);
	app.enableCors();
	app.useGlobalPipes(
		new ValidationPipe({
			exceptionFactory,
		})
	);
	await app.listen(3000);
}

bootstrap();
