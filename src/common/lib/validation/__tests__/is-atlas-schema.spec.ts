import { validate } from 'class-validator';

import { IsAtlasSchema } from '../is-atlas-schema';

it.each([
	['12345', false],
	[{}, false],
	[[], false],
	[{}, false],
	[{ version: 'a', data: [] }, false],
	[{ version: '1' }, false],
	[{ version: '1', data: [] }, true],
])('validates %p as %p', async (schema: any, expected) => {
	class TestClass {
		@IsAtlasSchema()
		atlas: object;
	}

	const record = new TestClass();

	record.atlas = schema;

	const errors = await validate(record);
	const isValid = !errors.length;

	expect(isValid).toBe(expected);
});
