import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const CurrentUser = createParamDecorator(
	(data: unknown, ctx: ExecutionContext) => {
		const response = ctx.switchToHttp().getResponse();
		return response.locals.user;
	}
);
