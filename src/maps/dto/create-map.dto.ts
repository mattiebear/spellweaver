import { PickType } from '@nestjs/mapped-types';

import { Map } from '../map.entity';

export class CreateMapDto extends PickType(Map, ['name'] as const) {}
