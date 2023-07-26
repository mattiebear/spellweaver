import { Policy } from '../policy';
import { Action } from '../types';

class Record {
	constructor(public userId: string) {}
}

it('returns true if the user is authorized', async () => {
	const policy = new Policy(Record);
	const userId = '1';

	policy.allow(Action.Read, (record, userId) => record.userId === userId);

	const record = new Record(userId);

	const isAuthorized = await policy.isAuthorized(Action.Read, record, userId);

	expect(isAuthorized).toBe(true);
});

it('returns false if the user is not authorized', async () => {
	const policy = new Policy(Record);

	policy.allow(Action.Read, (record, userId) => record.userId === userId);

	const record = new Record('id-1');

	const isAuthorized = await policy.isAuthorized(Action.Read, record, 'id-2');

	expect(isAuthorized).toBe(false);
});

it('functions with async actions', async () => {
	const policy = new Policy(Record);

	policy.allow(Action.Read, async () => Promise.resolve(true));

	const record = new Record('id');

	const isAuthorized = await policy.isAuthorized(Action.Read, record, 'id');

	expect(isAuthorized).toBe(true);
});
