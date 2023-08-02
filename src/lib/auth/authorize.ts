import { HttpError, HttpStatus } from '../http';
import { Policy } from './policy';
import { Action } from './types';

interface CreateAuthorizeConfig {
	policies: Policy[];
}

export const createAuthorize = ({ policies }: CreateAuthorizeConfig) => {
	return async (action: Action, record: any, userId: string, context?: any) => {
		const policy = policies.find((policy) => record instanceof policy.entity);

		if (!policy) {
			throw new HttpError(HttpStatus.Forbidden);
		}

		const isAuthorized = await policy.isAuthorized(
			action,
			record,
			userId,
			context
		);

		if (!isAuthorized) {
			throw new HttpError(HttpStatus.Forbidden);
		}

		return true;
	};
};
