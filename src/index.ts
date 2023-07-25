import 'reflect-metadata';

import { db } from './db';
import { ENV, app } from './lib/application';

db.initialize().then(() => {
	const port = ENV.fetch('PORT');

	app.listen(port);

	console.log(`Listening on port ${port}`);
});
