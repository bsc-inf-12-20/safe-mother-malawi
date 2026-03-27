import { Controller, Post, Get, Body } from '@nestjs/common';
import { AlertsService } from './alerts.service';

class CreateSosDto {
  motherId: string;
  timestamp: string;
  lat?: number;
  lng?: number;
}

@Controller('alerts')
export class AlertsController {
  constructor(private readonly alertsService: AlertsService) {}

  @Post('sos')
  createSos(@Body() dto: CreateSosDto) {
    return this.alertsService.createSosAlert(dto);
  }

  @Get()
  listAlerts() {
    return this.alertsService.getAllAlerts();
  }
}
