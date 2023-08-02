import { Connection, ConnectionStatus } from '../../entity';
import { Action, Policy } from '../../lib/auth';
import { isOwnedByUser } from '../verifiers';

export const connectionPolicy = new Policy(Connection)
	.allow(Action.Update, isOwnedByUser)
	.allow(
		Action.Update,
		(record: Connection, _userId, { status }: { status: ConnectionStatus }) => {
			switch (status) {
				case ConnectionStatus.AwaitingResponse:
					return false;

				case ConnectionStatus.PendingAcceptance:
					return false;

				case ConnectionStatus.Accepted:
					return record.status === ConnectionStatus.PendingAcceptance;

				case ConnectionStatus.Rejected:
					return record.status === ConnectionStatus.PendingAcceptance;

				case ConnectionStatus.Removed:
					return true;

				default:
					return false;
			}
		}
	);
