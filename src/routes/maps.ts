import Router from '@koa/router';
import { validate } from 'class-validator';

import { mapRepository } from '../db';
import { Map } from '../models';
import { AppState } from '../types/state';

const router = new Router();

interface MapCreateBody {
	name: string;
}

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
		console.log(errors);
		throw new Error('Invalid map');
	}

	const record = await mapRepository.save(map);

	// TODO: Create enum for status codes
	ctx.body = record;
	ctx.status = 201;
});

export { router };
