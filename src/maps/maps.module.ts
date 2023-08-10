import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Map } from './map.entity';
import { MapsController } from './maps.controller';
import { MapsService } from './maps.service';

@Module({
	imports: [TypeOrmModule.forFeature([Map])],
	providers: [MapsService],
	controllers: [MapsController],
})
export class MapsModule {}
