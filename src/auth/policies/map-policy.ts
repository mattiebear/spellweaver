import { Map } from '../../entity';
import { Action, Policy } from '../../lib/auth';
import { isOwnedByUser } from '../verifiers';

export const mapPolicy = new Policy(Map).allow(
	[Action.Read, Action.Create, Action.Delete, Action.Update],
	isOwnedByUser
);
