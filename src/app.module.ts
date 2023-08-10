import { MiddlewareConsumer, Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

import { ACLModule } from './acl/acl.module';
import { JwtMiddleware } from './common/middleware/jwt.middleware';
import { DBConfigService } from './common/providers/db-config.service';
import { JwtService } from './common/providers/jwt.service';
import { ConnectionsModule } from './connections/connections.module';
import { HealthModule } from './health/health.module';
import { MapsModule } from './maps/maps.module';

@Module({
	imports: [
		ConfigModule.forRoot({
			envFilePath: ['.env.development.local', '.env.development'],
			isGlobal: true,
		}),
		TypeOrmModule.forRootAsync({
			imports: [ConfigModule],
			useClass: DBConfigService,
			inject: [ConfigService],
		}),
		ACLModule,
		ConnectionsModule,
		MapsModule,
		HealthModule,
	],
	providers: [ConfigService, JwtService],
})
export class AppModule {
	configure(consumer: MiddlewareConsumer) {
		consumer.apply(JwtMiddleware).forRoutes('*');
	}
}
