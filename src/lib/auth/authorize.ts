import { HttpError, HttpStatus } from '../http';
import { Policy } from './policy';
import { Action } from './types';

interface CreateAuthorizeConfig {
	policies: Policy[];
}

export const createAuthorize = ({ policies }: CreateAuthorizeConfig) => {
	return async (action: Action, record: any, userId: string) => {
		const policy = policies.find((policy) => record instanceof policy.entity);

		if (policy) {
			const isAuthorized = await policy.isAuthorized(action, record, userId);

			if (!isAuthorized) {
				throw new HttpError(HttpStatus.Forbidden);
			}
		}

		return true;
	};
};
