import {
	CreateDateColumn,
	Entity,
	ManyToOne,
	OneToMany,
	PrimaryGeneratedColumn,
	UpdateDateColumn,
} from 'typeorm';

import { Map } from '../maps/map.entity';
import { SessionUser } from './session-user.entity';

@Entity('sessions')
export class Session {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@OneToMany(() => SessionUser, (sessionUser) => sessionUser.session)
	sessionUsers: SessionUser[];

	@ManyToOne(() => Map)
	map: Map;

	@CreateDateColumn()
	createdAt: Date;

	@UpdateDateColumn()
	updatedAt: Date;
}
