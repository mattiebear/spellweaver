import clerk from '@clerk/clerk-sdk-node';
import Router from '@koa/router';
import { Not } from 'typeorm';

import { associateWithUser } from '../auth/user';
import { connectionRepository } from '../db/connection-repositoy';
import { ConnectionStatus } from '../entity';
import { HttpStatus } from '../lib/http';
import { RequestConnectionService } from '../services/connections/request-connection-service';
import { AppState } from '../types/state';

const router = new Router<AppState>();

interface ConnectionRequestCreateBody {
	username: string;
}

router.post('/request', async (ctx) => {
	const service = new RequestConnectionService({
		userId: ctx.state.userId,
		username: (ctx.request.body as ConnectionRequestCreateBody).username,
	});

	await service.run();

	ctx.body = service.result();
	ctx.status = HttpStatus.Created;
});

router.get<AppState>('/', async (ctx) => {
	const connections = await connectionRepository.findBy({
		status: Not(ConnectionStatus.Rejected),
		userId: ctx.state.userId,
	});

	const associated = await associateWithUser(connections, {
		fKey: 'connectedUserId',
		recordKey: 'connectedUser',
	});

	ctx.body = associated;
	ctx.status = HttpStatus.OK;
});

export { router };
