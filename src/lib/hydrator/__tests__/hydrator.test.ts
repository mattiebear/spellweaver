import { Hydrator } from '../hydrator';

it('transfers properties from a source', () => {
	const ctx = {
		request: {
			body: {
				a: 1,
				b: 2,
			},
		},
	};

	const result = new Hydrator(ctx as any).to({}).hydrates('a', 'b').entity();

	expect(result).toEqual({
		a: 1,
		b: 2,
	});
});

it('transfers only specified properties', () => {
	const ctx = {
		request: {
			body: {
				a: 1,
				b: 2,
			},
		},
	};

	const result = new Hydrator(ctx as any).to({}).hydrates('b').entity();

	expect(result).toEqual({
		b: 2,
	});
});

it('transfers contextual user ID', () => {
	const ctx = {
		state: {
			userId: 'id',
		},
		request: {
			body: {
				a: 1,
				b: 2,
			},
		},
	};

	const result = new Hydrator(ctx as any)
		.to({})
		.hydrates('b', 'userId')
		.entity();

	expect(result).toEqual({
		b: 2,
		userId: 'id',
	});
});

it('adds supplied values', () => {
	const ctx = {
		state: {
			userId: 'id',
		},
		request: {
			body: {
				a: 1,
				b: 2,
			},
		},
	};

	const result = new Hydrator(ctx as any)
		.to({})
		.hydrates('a')
		.supplies({ c: 3 })
		.entity();

	expect(result).toEqual({
		a: 1,
		c: 3,
	});
});
