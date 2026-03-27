import { Injectable } from '@nestjs/common';

export interface SosAlert {
  alertId: string;
  motherId: string;
  timestamp: string;
  lat?: number;
  lng?: number;
  receivedAt: string;
}

@Injectable()
export class AlertsService {
  private readonly alerts: SosAlert[] = [];

  createSosAlert(dto: {
    motherId: string;
    timestamp: string;
    lat?: number;
    lng?: number;
  }): { success: boolean; alertId: string } {
    const alertId = `alert_${Date.now()}_${Math.random().toString(36).slice(2, 9)}`;
    this.alerts.push({
      alertId,
      motherId: dto.motherId,
      timestamp: dto.timestamp,
      lat: dto.lat,
      lng: dto.lng,
      receivedAt: new Date().toISOString(),
    });
    return { success: true, alertId };
  }

  getAllAlerts(): SosAlert[] {
    return this.alerts;
  }
}
