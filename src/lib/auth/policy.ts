import { Action } from './types';

type Verifier = (record: any, userId: string) => boolean | Promise<boolean>;

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

	async isAuthorized(action: Action, record: any, userId: string) {
		for (const verifier of this.forAction(action)) {
			const authorized = await verifier(record, userId);

			if (!authorized) {
				return false;
			}
		}

		return true;
	}
}
