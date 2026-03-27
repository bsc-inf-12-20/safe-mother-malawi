import { Controller, Post, Get, Body } from '@nestjs/common';
import { HealthChecksService, HealthCheckResponse } from './health-checks.service';

class CreateHealthCheckDto {
  motherId: string;
  timestamp: string;
  responses: HealthCheckResponse[];
  hasDangerSign: boolean;
}

@Controller('health-checks')
export class HealthChecksController {
  constructor(private readonly healthChecksService: HealthChecksService) {}

  @Post()
  create(@Body() dto: CreateHealthCheckDto) {
    return this.healthChecksService.create(dto);
  }

  @Get()
  findAll() {
    return this.healthChecksService.findAll();
  }
}
