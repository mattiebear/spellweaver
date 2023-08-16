import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { UsersModule } from '../users/users.module';
import { SessionUser } from './session-user.entity';
import { Session } from './session.entity';

@Module({
	imports: [TypeOrmModule.forFeature([Session, SessionUser]), UsersModule],
})
export class SessionsModule {}
