# Feature        : Attribute-Based Access Control (ABAC) — FastAPI policy engine
# Language       : Python 3.11
# Framework      : FastAPI 0.110
# Level          : Advanced
# OWASP          : A01 — Broken Access Control
# Protects       : Against context-insensitive access decisions
# Does NOT cover : Distributed PDP, external policy engines (OPA, Cedar)
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, FastAPI 0.110.0, pydantic 2.6.3
# Last reviewed  : 2024-03-01

import os
from dataclasses import dataclass
from typing import Annotated, Callable
import datetime
from fastapi import FastAPI, Depends, HTTPException, Request, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from pydantic import BaseModel

SECRET_KEY = os.environ.get("SECRET_KEY")
ALGORITHM  = "RS256"
app        = FastAPI()
bearer     = HTTPBearer()


@dataclass(frozen=True)
class Subject:
    user_id: str
    role: str
    department: str
    mfa_verified: bool
    clearance: int


@dataclass(frozen=True)
class Resource:
    id: str
    owner_id: str
    status: str
    clearance_required: int


@dataclass(frozen=True)
class Environment:
    is_business_hours: bool
    ip: str


PolicyFn = Callable[[Subject, Resource, Environment], tuple[bool, str]]


def decode_subject(creds: HTTPAuthorizationCredentials = Depends(bearer)) -> Subject:
    try:
        p = jwt.decode(creds.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        return Subject(
            user_id=p["sub"], role=p.get("role","viewer"),
            department=p.get("dept","general"),
            mfa_verified=p.get("mfa", False), clearance=p.get("clearance", 1)
        )
    except JWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)


def build_env(request: Request) -> Environment:
    now = datetime.datetime.utcnow()
    return Environment(
        is_business_hours=9 <= now.hour < 18 and now.weekday() < 5,
        ip=request.client.host or "unknown"
    )


def enforce(policy: PolicyFn, get_resource: Callable[..., Resource]):
    """Dependency factory — apply ABAC policy to a route."""
    def dependency(
        subject: Annotated[Subject, Depends(decode_subject)],
        env: Annotated[Environment, Depends(build_env)],
        resource: Annotated[Resource, Depends(get_resource)],
    ) -> Subject:
        allowed, reason = policy(subject, resource, env)
        if not allowed:
            raise HTTPException(status_code=403, detail=reason)
        return subject
    return dependency


# ── Policies ──────────────────────────────────────────────────────────────────

def can_read(s: Subject, r: Resource, e: Environment) -> tuple[bool, str]:
    if r.status == "published" and s.clearance >= r.clearance_required:
        return True, "published + clearance"
    if r.owner_id == s.user_id:
        return True, "owner"
    if s.role in ("editor","admin"):
        return True, "editor/admin"
    return False, "no matching read policy"


def can_edit(s: Subject, r: Resource, e: Environment) -> tuple[bool, str]:
    if r.status == "archived":
        return False, "archived documents are immutable"
    if r.owner_id == s.user_id and r.status == "draft":
        return True, "owner editing draft"
    if s.role == "admin" and e.is_business_hours and s.mfa_verified:
        return True, "admin during business hours with MFA"
    return False, "no matching edit policy"


def can_delete(s: Subject, r: Resource, e: Environment) -> tuple[bool, str]:
    if s.role != "admin" or not s.mfa_verified:
        return False, "requires admin + MFA"
    return True, "admin with MFA"


# ── Resource loaders (replace with DB calls) ──────────────────────────────────

async def get_document(doc_id: str) -> Resource:
    return Resource(id=doc_id, owner_id="user_42", status="draft", clearance_required=1)


# ── Routes ────────────────────────────────────────────────────────────────────

@app.get("/documents/{doc_id}")
async def read_doc(
    doc_id: str,
    subject: Annotated[Subject, Depends(enforce(can_read, get_document))]
):
    return {"doc": doc_id, "user": subject.user_id}


@app.patch("/documents/{doc_id}")
async def edit_doc(
    doc_id: str,
    subject: Annotated[Subject, Depends(enforce(can_edit, get_document))]
):
    return {"updated": doc_id}


@app.delete("/documents/{doc_id}")
async def delete_doc(
    doc_id: str,
    subject: Annotated[Subject, Depends(enforce(can_delete, get_document))]
):
    return {"deleted": doc_id}
