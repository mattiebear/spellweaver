import { PartialType, PickType } from '@nestjs/mapped-types';

import { Map } from '../map.entity';

export class UpdateMapDto extends PartialType(
	PickType(Map, ['atlas', 'name'] as const)
) {}
