import { Injectable, Logger } from '@nestjs/common';

export interface HealthCheckResponse {
  question: string;
  answer: string;
}

export interface HealthCheckRecord {
  id: string;
  motherId: string;
  timestamp: string;
  responses: HealthCheckResponse[];
  hasDangerSign: boolean;
  receivedAt: string;
}

@Injectable()
export class HealthChecksService {
  private readonly logger = new Logger(HealthChecksService.name);
  private readonly records: HealthCheckRecord[] = [];

  create(dto: {
    motherId: string;
    timestamp: string;
    responses: HealthCheckResponse[];
    hasDangerSign: boolean;
  }): { success: boolean; id: string } {
    const id = `hc_${Date.now()}_${Math.random().toString(36).slice(2, 9)}`;

    this.records.push({
      id,
      motherId: dto.motherId,
      timestamp: dto.timestamp,
      responses: dto.responses,
      hasDangerSign: dto.hasDangerSign,
      receivedAt: new Date().toISOString(),
    });

    if (dto.hasDangerSign) {
      this.logger.warn(
        `[CLINICIAN ALERT] Danger sign detected for mother ${dto.motherId} at ${dto.timestamp}. Immediate review required.`,
      );
    }

    return { success: true, id };
  }

  findAll(): HealthCheckRecord[] {
    return this.records;
  }
}
