import Router from '@koa/router';
import { Not } from 'typeorm';

import { Action, authorize } from '../auth';
import { associateWithUser } from '../auth/user';
import { connectionRepository } from '../db/connection-repositoy';
import { ConnectionStatus } from '../entity';
import {
	ErrorCode,
	HttpError,
	HttpStatus,
	UnprocessableError,
} from '../lib/http';
import { RequestConnectionService } from '../services/connections/request-connection-service';
import { UpdateConnectionService } from '../services/connections/update-connection-service';
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

router.get('/', async (ctx) => {
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

interface ConnectionPatchBody {
	status: ConnectionStatus;
}

router.patch('/:id', async (ctx) => {
	const connection = await connectionRepository.findOneBy({
		id: ctx.params.id,
	});

	if (!connection) {
		throw new HttpError(HttpStatus.NotFound);
	}

	const status = (ctx.request.body as ConnectionPatchBody)?.status;

	if (!Object.values(ConnectionStatus).includes(status)) {
		throw new UnprocessableError().add('status', ErrorCode.Invalid);
	}

	await authorize(Action.Update, connection, ctx.state.userId, { status });

	const service = new UpdateConnectionService({
		connection,
		status,
	});

	await service.run();

	ctx.body = service.result();
	ctx.status = HttpStatus.OK;
});

export { router };
