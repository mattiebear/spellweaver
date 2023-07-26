import Router from '@koa/router';
import { validate } from 'class-validator';

import { mapRepository } from '../db';
import { Map } from '../entity';
import { HttpError, HttpStatus } from '../lib/http';
import { Hydrator } from '../lib/hydrator';
import { AppState } from '../types/state';

const router = new Router<AppState>();

interface MapCreateBody {
	name: string;
}

// POST new map
router.post<{}, {}, MapCreateBody>('/', async (ctx) => {
	const map = new Hydrator(ctx)
		.to(new Map())
		.hydrates('name', 'userId')
		.supplies({ atlas: { version: '1', data: [] } })
		.entity();

	// await authorize(map, ctx.state.userId, Action.Read);

	// TODO: Create validation util to automatically throw
	const errors = await validate(map);

	if (errors.length > 0) {
		// TODO: Throw custom error with list of errors to display
		throw new Error('Invalid map');
	}

	ctx.body = await mapRepository.save(map);
	ctx.status = HttpStatus.Created;
});

// GET all maps
router.get<AppState>('/', async (ctx) => {
	ctx.body = await mapRepository.findBy({ userId: ctx.state.userId });
	ctx.status = HttpStatus.OK;
});

// GET map by id
router.get<AppState, { id: string }>('/:id', async (ctx) => {
	const map = await mapRepository.findOneBy({
		userId: ctx.state.userId,
		id: ctx.params.id,
	});

	if (!map) {
		throw new HttpError(HttpStatus.NotFound);
	}

	// TODO: Authorize
	ctx.body = map;
	ctx.status = HttpStatus.OK;
});

interface MapPutBody {
	atlas?: object;
	name?: string;
}

interface MapPatchBody extends Partial<MapPutBody> {}

// PATCH map by id
router.patch<AppState, { id: string }, MapPatchBody>('/:id', async (ctx) => {
	const record = await mapRepository.findOneBy({
		userId: ctx.state.userId,
		id: ctx.params.id,
	});

	if (!record) {
		throw new HttpError(HttpStatus.NotFound);
	}

	const map = new Hydrator(ctx).to(record).hydrates('atlas', 'name').entity();

	const errors = await validate(map);

	if (errors.length > 0) {
		// TODO: Throw custom error with list of errors to display
		throw new Error('Invalid map');
	}

	ctx.body = await mapRepository.save(map);
	ctx.status = HttpStatus.OK;
});

// DELETE map by id
router.delete<AppState, { id: string }>('/:id', async (ctx) => {
	const map = await mapRepository.findOneBy({
		userId: ctx.state.userId,
		id: ctx.params.id,
	});

	if (!map) {
		throw new HttpError(HttpStatus.NotFound);
	}

	await mapRepository.remove(map);

	ctx.status = HttpStatus.NoContent;
});

export { router };
