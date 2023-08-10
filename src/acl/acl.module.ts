import { Global, Module } from '@nestjs/common';

import { AclService } from './acl.service';

@Global()
@Module({
	providers: [AclService],
	exports: [AclService],
})
export class ACLModule {}
