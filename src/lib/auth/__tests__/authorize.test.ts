import { createAuthorize } from '../authorize';
import { Policy } from '../policy';
import { Action } from '../types';

class Record {
	constructor(public userId: string) {}
}

it('authorizes a record', async () => {
	const policy = new Policy(Record).allow(
		Action.Read,
		(record, userId) => record.userId === userId
	);

	const authorize = createAuthorize({ policies: [policy] });

	const record = new Record('1');

	const isAuthorized = await authorize(Action.Read, record, '1');

	expect(isAuthorized).toBe(true);
});

it('throws an error if not authorized', async () => {
	const policy = new Policy(Record).allow(
		Action.Read,
		(record, userId) => record.userId === userId
	);

	const authorize = createAuthorize({ policies: [policy] });

	const record = new Record('1');

	await expect(authorize(Action.Read, record, '2')).rejects.toThrowError();
});
