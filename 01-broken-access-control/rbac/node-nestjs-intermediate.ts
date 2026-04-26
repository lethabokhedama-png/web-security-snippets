// Feature        : Role-Based Access Control (RBAC) — NestJS Guard + Decorator
// Language       : TypeScript / Node.js 20
// Framework      : NestJS 10
// Level          : Intermediate
// OWASP          : A01 — Broken Access Control
// Protects       : Route-level role enforcement using NestJS Guards
// Does NOT cover : Permission-level granularity, ABAC
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.14.0, NestJS 10.3.9
// Last reviewed  : 2024-06-01

import { CanActivate, ExecutionContext, Injectable, SetMetadata } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';

// Custom decorator — attaches required roles to the route metadata
export const Roles = (...roles: string[]) => SetMetadata('roles', roles);

const ROLE_LEVELS: Record<string, number> = {
  viewer:    1,
  editor:    2,
  moderator: 3,
  admin:     4,
};

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private jwtService: JwtService,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    // Read which roles are required for this route
    const required = this.reflector.getAllAndOverride<string[]>('roles', [
      context.getHandler(),
      context.getClass(),
    ]);

    // No @Roles() decorator — route is publicly accessible
    if (!required || required.length === 0) return true;

    const request = context.switchToHttp().getRequest();
    const authHeader: string = request.headers['authorization'] ?? '';
    if (!authHeader.startsWith('Bearer ')) return false;

    let payload: any;
    try {
      payload = this.jwtService.verify(authHeader.slice(7));
    } catch {
      return false;
    }

    const userLevel = ROLE_LEVELS[payload?.role] ?? 0;
    const minRequired = Math.min(...required.map(r => ROLE_LEVELS[r] ?? Infinity));
    request.user = payload;
    return userLevel >= minRequired;
  }
}

// ── Usage in a NestJS controller ──────────────────────────
// @Controller('admin')
// @UseGuards(JwtAuthGuard, RolesGuard)
// export class AdminController {
//
//   @Get('users')
//   @Roles('admin')
//   listUsers() { ... }
//
//   @Get('posts')
//   @Roles('editor', 'admin')
//   listPosts() { ... }
// }
