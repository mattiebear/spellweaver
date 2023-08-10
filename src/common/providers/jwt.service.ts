import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as jwt from 'jsonwebtoken';
import { JwksClient } from 'jwks-rsa';

interface DecodedToken {
	azp: string;
	exp: number;
	iat: number;
	iss: string;
	nbf: number;
	sid: string;
	sub: string;
}

@Injectable()
export class JwtService {
	private client: JwksClient;

	constructor(private configService: ConfigService) {
		this.client = new JwksClient({
			jwksUri: configService.get<string>('JWKS_URI'),
		});
	}

	// TODO: Verify issuer and expirations

	public async verify(token: string): Promise<DecodedToken> {
		return new Promise((resolve, reject) => {
			const getKey = async (header, callback) => {
				const key = await this.client.getSigningKey(header.kid);
				callback(null, key.getPublicKey());
			};

			jwt.verify(token, getKey, (err, key) => {
				if (err) {
					return reject(err);
				}

				resolve(key);
			});
		});
	}
}
