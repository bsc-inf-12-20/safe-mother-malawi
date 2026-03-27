import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import * as bcryptjs from 'bcryptjs';
import { AuthAuditService } from './auth-audit.service';
import { LoginResponseDto } from './dto/login-response.dto';

interface Mother {
  id: string;
  phone: string;
  pinHash: string;
  fullName: string;
}

@Injectable()
export class AuthService {
  private readonly mothers: Map<string, Mother> = new Map([
    [
      '+265999000000',
      {
        id: 'PAT-00041',
        phone: '+265999000000',
        pinHash: bcryptjs.hashSync('1234', 10),
        fullName: 'Grace Nkosi',
      },
    ],
    [
      '+265888000000',
      {
        id: 'PAT-00042',
        phone: '+265888000000',
        pinHash: bcryptjs.hashSync('5678', 10),
        fullName: 'Faith Mwale',
      },
    ],
  ]);

  private readonly failedAttempts: Map<string, number> = new Map();
  private readonly lockedUntil: Map<string, Date> = new Map();

  constructor(private readonly auditService: AuthAuditService) {}

  async login(phone: string, pin: string, deviceId?: string): Promise<LoginResponseDto> {
    const lockExpiry = this.lockedUntil.get(phone);
    if (lockExpiry && lockExpiry > new Date()) {
      const remainingSeconds = Math.ceil((lockExpiry.getTime() - Date.now()) / 1000);
      throw new HttpException(
        { message: 'Account locked', remainingSeconds },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const mother = this.mothers.get(phone);
    if (!mother) {
      throw new HttpException({ message: 'Invalid credentials' }, HttpStatus.UNAUTHORIZED);
    }

    const valid = await bcryptjs.compare(pin, mother.pinHash);
    if (!valid) {
      const attempts = (this.failedAttempts.get(phone) ?? 0) + 1;
      this.failedAttempts.set(phone, attempts);

      if (attempts >= 5) {
        const until = new Date(Date.now() + 15 * 60 * 1000);
        this.lockedUntil.set(phone, until);
      }

      this.auditService.log('failed_login', phone, deviceId);
      throw new HttpException({ message: 'Invalid credentials' }, HttpStatus.UNAUTHORIZED);
    }

    this.failedAttempts.delete(phone);
    this.lockedUntil.delete(phone);
    this.auditService.log('login', phone, deviceId);

    const payload = { sub: mother.id, phone, iat: Date.now() };
    const accessToken = Buffer.from(JSON.stringify(payload)).toString('base64');

    return { accessToken, expiresIn: 86400 };
  }

  logout(phone: string, deviceId?: string): void {
    this.auditService.log('logout', phone, deviceId);
  }
}
