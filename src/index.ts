import 'reflect-metadata';

import { db } from './db';
import { app } from './lib/application/app';
import { ENV } from './lib/application/env';

db.initialize().then(() => {
	const port = ENV.fetch('PORT');

	app.listen(port);

	console.log(`Listening on port ${port}`);
});
