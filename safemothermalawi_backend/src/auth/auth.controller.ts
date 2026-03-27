import { Controller, Post, Get, Body, Headers } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthAuditService, AuditLog } from './auth-audit.service';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly authAuditService: AuthAuditService,
  ) {}

  @Post('login')
  async login(@Body() dto: LoginDto, @Headers('device-id') deviceId?: string) {
    return this.authService.login(dto.phone, dto.pin, deviceId);
  }

  @Post('logout')
  logout(@Body('phone') phone: string, @Headers('device-id') deviceId?: string) {
    this.authService.logout(phone, deviceId);
    return { message: 'Logged out' };
  }

  @Get('audit')
  getAuditLogs(): AuditLog[] {
    return this.authAuditService.getLogs();
  }
}
