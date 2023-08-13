import { IsIn } from 'class-validator';
import { pick } from 'ramda';
import {
	Column,
	CreateDateColumn,
	Entity,
	JoinColumn,
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

interface ConstructorArgs {
	connectionId: string;
	role: ConnectionRole;
	userId: string;
}

@Entity('connection_users')
export class ConnectionUser {
	constructor(data: Partial<ConstructorArgs> = {}) {
		console.log('data is', pick(['connectionId', 'role', 'userId'], data));

		Object.assign(this, pick(['connectionId', 'role', 'userId'], data));
	}

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
