import { Length } from 'class-validator';
import {
	Column,
	CreateDateColumn,
	Entity,
	PrimaryGeneratedColumn,
	UpdateDateColumn,
} from 'typeorm';

import { IsAtlasSchema, IsUserId } from '../common/lib/validation';

@Entity('maps')
export class Map {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column()
	@IsUserId()
	userId: string;

	@Column()
	@Length(1, 255)
	name: string;

	@Column('json', {
		default: {
			version: '0',
			data: [],
		},
	})
	@IsAtlasSchema()
	atlas: object;

	@CreateDateColumn()
	createdAt: Date;

	@UpdateDateColumn()
	updatedAt: Date;
}
