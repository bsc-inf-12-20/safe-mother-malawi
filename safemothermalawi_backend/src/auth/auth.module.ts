import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { AuthAuditService } from './auth-audit.service';

@Module({
  controllers: [AuthController],
  providers: [AuthService, AuthAuditService],
})
export class AuthModule {}
