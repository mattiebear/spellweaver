import { IsIn } from 'class-validator';
import {
	Column,
	CreateDateColumn,
	Entity,
	PrimaryGeneratedColumn,
	UpdateDateColumn,
} from 'typeorm';

import { IsUserId } from '../lib/validation';

export enum ConnectionStatus {
	PendingAcceptance = 'pending',
	AwaitingResponse = 'awaiting',
	Accepted = 'accepted',
}

@Entity('connections')
export class Connection {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column()
	@IsUserId()
	userId: string;

	@Column({
		type: 'enum',
		enum: ConnectionStatus,
		default: ConnectionStatus.PendingAcceptance,
	})
	@IsIn(Object.values(ConnectionStatus))
	status: ConnectionStatus;

	@CreateDateColumn()
	createdAt: Date;

	@UpdateDateColumn()
	updatedAt: Date;
}
