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
import { Connection } from './connection.entity';

export enum ConnectionRole {
	Requester = 'requester',
	Recipient = 'recipient',
}

@Entity('connection_users')
export class ConnectionUser {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column()
	@IsUserId()
	userId: string;

	@Column({
		type: 'enum',
		enum: ConnectionRole,
	})
	@IsIn(Object.values(ConnectionRole))
	role: ConnectionRole;

	@ManyToOne(() => Connection, (connection) => connection.connectionUsers)
	connection: Connection;

	user: User;

	@CreateDateColumn()
	createdAt: Date;

	@UpdateDateColumn()
	updatedAt: Date;
}
