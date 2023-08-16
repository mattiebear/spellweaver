import { IsIn } from 'class-validator';
import {
	Column,
	CreateDateColumn,
	Entity,
	ManyToOne,
	PrimaryGeneratedColumn,
	UpdateDateColumn,
} from 'typeorm';

import { IsUserId } from '../common/lib/validation';
import { User } from '../users/user.entity';
import { Session } from './session.entity';

export enum SessionRole {
	Master = 'master',
	Player = 'player',
}

@Entity('session_users')
export class SessionUser {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column()
	@IsUserId()
	userId: string;

	@Column({
		type: 'enum',
		enum: SessionRole,
		default: SessionRole.Player,
	})
	@IsIn(Object.values(SessionRole))
	role: SessionRole;

	@ManyToOne(() => Session, (session) => session.sessionUsers)
	session: Session;

	user: User;

	@CreateDateColumn()
	createdAt: Date;

	@UpdateDateColumn()
	updatedAt: Date;
}
