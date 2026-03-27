import { Injectable } from '@nestjs/common';

export interface AuditLog {
  event: string;
  phone: string;
  timestamp: Date;
  deviceId: string;
}

@Injectable()
export class AuthAuditService {
  private logs: AuditLog[] = [];

  log(event: string, phone: string, deviceId?: string): void {
    this.logs.push({
      event,
      phone,
      timestamp: new Date(),
      deviceId: deviceId ?? 'unknown',
    });
  }

  getLogs(): AuditLog[] {
    return this.logs;
  }
}
