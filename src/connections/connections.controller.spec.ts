import { Test, TestingModule } from '@nestjs/testing';

import { ConnectionsController } from './connections.controller';
import { ConnectionsService } from './connections.service';

describe('ConnectionsController', () => {
	let controller: ConnectionsController;
	let mockConnectionsService = {};

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			controllers: [ConnectionsController],
			providers: [
				{ provide: ConnectionsService, useValue: mockConnectionsService },
			],
		}).compile();

		controller = module.get<ConnectionsController>(ConnectionsController);
	});

	it('should be defined', () => {
		expect(controller).toBeDefined();
	});
});
