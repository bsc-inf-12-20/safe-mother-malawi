import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { AlertsModule } from './alerts/alerts.module';
import { HealthChecksModule } from './health-checks/health-checks.module';

@Module({
  imports: [AuthModule, AlertsModule, HealthChecksModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
