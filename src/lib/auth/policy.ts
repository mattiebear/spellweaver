import { Action } from './types';

type Verifier = (
	record: any,
	userId: string,
	params?: any
) => boolean | Promise<boolean>;

export class Policy {
	private verifiers: [Action, Verifier][] = [];

	constructor(public entity: { new (...args: any[]): any }) {}

	allow(action: Action | Action[], verifier: Verifier) {
		const actions = Array.isArray(action) ? action : [action];

		actions.forEach((action) => {
			this.verifiers.push([action, verifier]);
		});

		return this;
	}

	forAction(action: Action) {
		return this.verifiers.reduce<Verifier[]>(
			(acc, [verifierAction, verifier]) => {
				if (verifierAction === action) {
					return acc.concat(verifier);
				}

				return acc;
			},
			[]
		);
	}

	async isAuthorized(
		action: Action,
		record: any,
		userId: string,
		context: any
	) {
		const actions = this.forAction(action);

		if (!actions.length) {
			return false;
		}

		for (const verifier of actions) {
			const authorized = await verifier(record, userId, context);

			if (!authorized) {
				return false;
			}
		}

		return true;
	}
}
