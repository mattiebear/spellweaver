import Router from '@koa/router';
import { validate } from 'class-validator';

import { mapRepository } from '../db';
import { Map } from '../entity';
import { HttpError, HttpStatus } from '../lib/http';
import { AppState } from '../types/state';

const router = new Router();

interface MapCreateBody {
	name: string;
}

// POST new map
router.post<AppState, {}, MapCreateBody>('/', async (ctx) => {
	const map = new Map();

	// TODO: Make some class to do this more efficiently
	map.userId = ctx.state.userId;
	// FIXME: Not sure why the types are not working here
	map.name = (ctx.request.body as MapCreateBody).name;
	map.atlas = {
		version: '1',
		data: [],
	};

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
	const map = await mapRepository.findOneBy({
		userId: ctx.state.userId,
		id: ctx.params.id,
	});

	if (!map) {
		throw new HttpError(HttpStatus.NotFound);
	}

	// TODO: Make util to only apply properties that are defined
	const atlas = (ctx.request.body as MapPatchBody).atlas;

	if (atlas) {
		map.atlas = atlas;
	}

	const name = (ctx.request.body as MapPatchBody).name;

	if (name) {
		map.name = name;
	}

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
