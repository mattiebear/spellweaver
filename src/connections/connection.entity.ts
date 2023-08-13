import { IsIn } from 'class-validator';
import {
	Column,
	CreateDateColumn,
	Entity,
	OneToMany,
	PrimaryGeneratedColumn,
	UpdateDateColumn,
} from 'typeorm';

import { IsUserId } from '../common/lib/validation';
import { ConnectionUser } from './connection-user.entity';

export enum ConnectionStatus {
	Pending = 'pending',
	Accepted = 'accepted',
}

@Entity('connections')
export class Connection {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column({
		type: 'enum',
		enum: ConnectionStatus,
		default: ConnectionStatus.Pending,
	})
	@IsIn(Object.values(ConnectionStatus))
	status: ConnectionStatus;

	@OneToMany(
		() => ConnectionUser,
		(connectionUser) => connectionUser.connection,
		{ cascade: ['remove'] }
	)
	connectionUsers: ConnectionUser[];

	@CreateDateColumn()
	createdAt: Date;

	@UpdateDateColumn()
	updatedAt: Date;
}
