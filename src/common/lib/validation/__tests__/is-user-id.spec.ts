import { validate } from 'class-validator';

import { IsUserId } from '../is-user-id';

it.each([
	['12345', false],
	['user_1234', true],
])('validates %s as %p', async (userId, expected) => {
	class TestClass {
		@IsUserId()
		userId: string;
	}

	const record = new TestClass();

	record.userId = userId;

	const errors = await validate(record);
	const isValid = !errors.length;

	expect(isValid).toBe(expected);
});
