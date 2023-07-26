export const isOwnedByUser = (record: any, userId: string) =>
	record.userId === userId;
