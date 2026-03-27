import { Module } from '@nestjs/common';
import { HealthChecksController } from './health-checks.controller';
import { HealthChecksService } from './health-checks.service';

@Module({
  controllers: [HealthChecksController],
  providers: [HealthChecksService],
})
export class HealthChecksModule {}
