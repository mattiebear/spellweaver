import Router from '@koa/router';
import { validate } from 'class-validator';

import { mapRepository } from '../db';
import { Map } from '../models';
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
	map.atlas = {};

	const errors = await validate(map);

	if (errors.length > 0) {
		// TODO: Throw custom error with list of errors to display
		throw new Error('Invalid map');
	}

	ctx.body = await mapRepository.save(map);
	// TODO: Create enum for status codes
	ctx.status = 201;
});

// GET all maps
router.get<AppState>('/', async (ctx) => {
	ctx.body = await mapRepository.findBy({ userId: ctx.state.userId });
	ctx.status = 200;
});

// GET map by id
router.get<AppState, { id: string }>('/:id', async (ctx) => {
	const map = await mapRepository.findOneBy({
		userId: ctx.state.userId,
		id: ctx.params.id,
	});

	// TODO: Authorize
	// TODO: Handle 404
	ctx.body = map;
	ctx.status = 200;
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

	// TODO: Handle 404
	if (!map) {
		throw new Error('Map not found');
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
	// TODO: Create enum for status codes
	ctx.status = 200;
});

export { router };
