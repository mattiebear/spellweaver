import { db } from './db/db';
import { app } from './lib/application';

db.initialize().then(() => {
	app.listen(3000);

	console.log('Listening on port 3000');
});
