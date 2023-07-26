import { ParameterizedContext } from 'koa';

export class Hydrator {
	private record: Record<string, unknown>;
	private properties: string[];
	private values: Record<string, unknown>;

	constructor(private ctx?: ParameterizedContext) {}

	to(record: any) {
		this.record = record;
		return this;
	}

	hydrates(...properties: string[]) {
		this.properties = properties;
		return this;
	}

	supplies(values: Record<string, unknown>) {
		this.values = values;
		return this;
	}

	entity() {
		if (this.properties.includes('userId') && this.ctxUserId) {
			Object.assign(this.record, { userId: this.ctxUserId });
		}

		for (const property of this.properties) {
			const value = this.ctxBodyValue(property);

			if (value !== undefined) {
				Object.assign(this.record, { [property]: value });
			}
		}

		if (this.values) {
			Object.assign(this.record, this.values);
		}

		return this.record;
	}

	private get ctxUserId() {
		if (this.ctx?.state && 'userId' in this.ctx.state) {
			return this.ctx.state.userId as string;
		}

		return undefined;
	}

	private ctxBodyValue(property: string) {
		return (this.ctx?.request?.body as any)[property];
	}
}
