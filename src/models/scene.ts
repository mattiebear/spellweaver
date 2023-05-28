import { Column, Entity, PrimaryGeneratedColumn } from "typeorm"

@Entity('scenes')
export class Scene {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column()
	userId: string;

	@Column()
	name: string;

	@Column('json')
	atlas: object;
}
