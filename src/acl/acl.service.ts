import { AbilityBuilder, createMongoAbility } from '@casl/ability';
import {
	ForbiddenException,
	Injectable,
	NotFoundException,
} from '@nestjs/common';

import { User } from '../users/user.entity';
import { Action } from './action';

@Injectable()
export class AclService {
	createForUser(user: User) {
		const { can, build } = new AbilityBuilder(createMongoAbility);

		can(Action.Read, 'Map');
		can(Action.Manage, 'Map', { userId: user.id });

		can([Action.Read, Action.Create], 'Connection');
		can(Action.Update, 'Connection', { userId: user.id });

		return build();
	}

	verify(record: any, user: User, action: Action) {
		if (!record) {
			throw new NotFoundException();
		}

		const ability = this.createForUser(user);

		if (ability.cannot(action, record)) {
			throw new ForbiddenException();
		}
	}

	verifyList(user: User, type: string) {
		const ability = this.createForUser(user);

		if (ability.cannot(Action.Read, type)) {
			throw new ForbiddenException();
		}
	}
}
