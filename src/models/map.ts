import { Length } from 'class-validator';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('maps')
export class Map {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column()
	userId: string;

	@Column()
	@Length(1, 255)
	name: string;

	@Column('json', { default: {} })
	atlas: object;
}
