// Feature        : Attribute-Based Access Control (ABAC) — NestJS policy guard
// Language       : TypeScript (Node.js 20)
// Framework      : NestJS 10
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Against context-insensitive access decisions
// Does NOT cover : External policy engines (OPA, Cedar)
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.11.1, NestJS 10.3.3
// Last reviewed  : 2024-03-01

import {
  Injectable, CanActivate, ExecutionContext,
  SetMetadata, UseGuards, Controller, Get, Patch, Delete,
  ForbiddenException, createParamDecorator,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';

// ── Attribute types ───────────────────────────────────────────────────────────

interface Subject   { userId: string; role: string; mfaVerified: boolean; clearance: number; }
interface Resource  { id: string; ownerId: string; status: string; clearanceRequired: number; }
interface Environment { isBusinessHours: boolean; ip: string; }

type PolicyFn = (s: Subject, r: Resource, e: Environment) => [boolean, string];

// ── Metadata key and decorator ────────────────────────────────────────────────

const POLICY_KEY = 'abac_policy';
export const AbacPolicy = (fn: PolicyFn) => SetMetadata(POLICY_KEY, fn);

// ── Current user decorator ────────────────────────────────────────────────────

export const CurrentUser = createParamDecorator(
  (_: unknown, ctx: ExecutionContext): Subject => ctx.switchToHttp().getRequest().user
);

// ── Policy guard ──────────────────────────────────────────────────────────────

@Injectable()
export class AbacGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    const policy = this.reflector.get<PolicyFn>(POLICY_KEY, ctx.getHandler());
    if (!policy) return true;

    const req     = ctx.switchToHttp().getRequest();
    const subject: Subject = req.user;
    const resource: Resource = req.resource;  // loaded by interceptor or route param pipe
    const now     = new Date();
    const env: Environment = {
      isBusinessHours: now.getUTCHours() >= 9 && now.getUTCHours() < 18 && now.getUTCDay() > 0 && now.getUTCDay() < 6,
      ip: req.ip,
    };

    const [allowed, reason] = policy(subject, resource, env);
    if (!allowed) throw new ForbiddenException(reason);
    return true;
  }
}

// ── Policies ──────────────────────────────────────────────────────────────────

const canRead: PolicyFn = (s, r, e) => {
  if (r.status === 'published' && s.clearance >= r.clearanceRequired) return [true, 'published + clearance'];
  if (r.ownerId === s.userId) return [true, 'owner'];
  return [false, 'no read policy matched'];
};

const canEdit: PolicyFn = (s, r, e) => {
  if (r.status === 'archived') return [false, 'archived'];
  if (r.ownerId === s.userId && r.status === 'draft') return [true, 'owner editing draft'];
  if (s.role === 'admin' && e.isBusinessHours && s.mfaVerified) return [true, 'admin+MFA+hours'];
  return [false, 'no edit policy matched'];
};

const canDelete: PolicyFn = (s, r, e) =>
  s.role === 'admin' && s.mfaVerified ? [true, 'admin+MFA'] : [false, 'requires admin+MFA'];

// ── Controller ────────────────────────────────────────────────────────────────

@Controller('documents')
@UseGuards(AbacGuard)
export class DocumentController {
  @Get(':id')
  @AbacPolicy(canRead)
  read(@CurrentUser() user: Subject) { return { user: user.userId }; }

  @Patch(':id')
  @AbacPolicy(canEdit)
  edit(@CurrentUser() user: Subject) { return { updated: true }; }

  @Delete(':id')
  @AbacPolicy(canDelete)
  remove(@CurrentUser() user: Subject) { return { deleted: true }; }
}
