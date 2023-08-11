import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersModule } from '../users/users.module';
import { ConnectionUser } from './connection-user.entity';
import { Connection } from './connection.entity';
import { ConnectionsController } from './connections.controller';
import { ConnectionsService } from './connections.service';

@Module({
	imports: [
		TypeOrmModule.forFeature([Connection, ConnectionUser]),
		UsersModule,
	],
	controllers: [ConnectionsController],
	providers: [ConnectionsService],
})
export class ConnectionsModule {}
