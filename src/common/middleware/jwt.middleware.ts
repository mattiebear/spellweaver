import {
	Injectable,
	NestMiddleware,
	UnauthorizedException,
} from '@nestjs/common';
import { NextFunction, Request, Response } from 'express';

import { User } from '../../users/user.entity';
import { JwtService } from '../providers/jwt.service';

@Injectable()
export class JwtMiddleware implements NestMiddleware {
	constructor(private jwtService: JwtService) {}

	async use(req: Request, res: Response, next: NextFunction) {
		const token = this.getTokenFromRequest(req);
		const decoded = await this.jwtService.verify(token);

		const user = new User();
		user.id = decoded.sub;

		res.locals.user = user;

		next();
	}

	private getTokenFromRequest(request: Request) {
		const authorization = request.headers.authorization;

		if (!authorization) {
			throw new UnauthorizedException();
		}

		const [type, token] = authorization.split(' ');

		if (type !== 'Bearer') {
			throw new UnauthorizedException();
		}

		return token;
	}
}
