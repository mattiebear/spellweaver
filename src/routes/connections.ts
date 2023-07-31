import Router from '@koa/router';

import { authorize } from '../auth';
import { mapRepository } from '../db';
import { Map } from '../entity';
import { Action } from '../lib/auth';
import { HttpError, HttpStatus } from '../lib/http';
import { Hydrator } from '../lib/hydrator';
import { validate } from '../lib/validation/validate';
import { RequestConnectionService } from '../services/connections/request-connection-service';
import { AppState } from '../types/state';

const router = new Router<AppState>();

interface ConnectionRequestCreateBody {
	username: string;
}

// POST a connection/request by searching for a user via username
router.post('/request', async (ctx) => {
	const service = new RequestConnectionService({
		userId: ctx.state.userId,
		username: (ctx.request.body as ConnectionRequestCreateBody).username,
	});

	await service.run();

	ctx.body = service.result();
	ctx.status = HttpStatus.Created;
});
//
// router.get<AppState>('/', async (ctx) => {
// 	ctx.body = await mapRepository.findBy({ userId: ctx.state.userId });
// 	ctx.status = HttpStatus.OK;
// });
//
// // GET map by id
// router.get<AppState, { id: string }>('/:id', async (ctx) => {
// 	const map = await mapRepository.findOneBy({
// 		id: ctx.params.id,
// 	});
//
// 	if (!map) {
// 		throw new HttpError(HttpStatus.NotFound);
// 	}
//
// 	await authorize(Action.Read, map, ctx.state.userId);
//
// 	ctx.body = map;
// 	ctx.status = HttpStatus.OK;
// });
//
// interface MapPutBody {
// 	atlas?: object;
// 	name?: string;
// }
//
// interface MapPatchBody extends Partial<MapPutBody> {}
//
// router.patch<AppState, { id: string }, MapPatchBody>('/:id', async (ctx) => {
// 	const record = await mapRepository.findOneBy({
// 		id: ctx.params.id,
// 	});
//
// 	if (!record) {
// 		throw new HttpError(HttpStatus.NotFound);
// 	}
//
// 	await authorize(Action.Update, record, ctx.state.userId);
//
// 	const map = new Hydrator(ctx).to(record).hydrates('atlas', 'name').entity();
//
// 	await validate(map);
//
// 	ctx.body = await mapRepository.save(map);
// 	ctx.status = HttpStatus.OK;
// });
//
// router.delete<AppState, { id: string }>('/:id', async (ctx) => {
// 	const map = await mapRepository.findOneBy({
// 		userId: ctx.state.userId,
// 		id: ctx.params.id,
// 	});
//
// 	await authorize(Action.Delete, map, ctx.state.userId);
//
// 	if (!map) {
// 		throw new HttpError(HttpStatus.NotFound);
// 	}
//
// 	await mapRepository.remove(map);
//
// 	ctx.status = HttpStatus.NoContent;
// });

export { router };
