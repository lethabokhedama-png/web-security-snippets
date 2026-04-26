# Feature        : Role-Based Access Control (RBAC) — FastAPI dependency injection
# Language       : Python 3.11
# Framework      : FastAPI 0.111 + python-jose
# Level          : Advanced
# OWASP          : A01 — Broken Access Control
# Protects       : Route-level and permission-level access enforcement via DI
# Does NOT cover : Attribute-based rules, field-level filtering
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, FastAPI 0.111.0, python-jose 3.3.0
# Last reviewed  : 2024-06-01

import os
from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException, Security, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import JWTError, jwt
from pydantic import BaseModel

app = FastAPI()
security_scheme = HTTPBearer()

JWT_SECRET    = os.environ["JWT_SECRET_KEY"]
JWT_ALGORITHM = "HS256"

ROLE_PERMISSIONS: dict[str, set[str]] = {
    "viewer":   {"posts:read"},
    "editor":   {"posts:read", "posts:write"},
    "admin":    {"posts:read", "posts:write", "posts:delete", "users:read", "users:write"},
}


class CurrentUser(BaseModel):
    user_id: str
    email: str
    role: str
    permissions: set[str]


def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials, Security(security_scheme)]
) -> CurrentUser:
    try:
        payload = jwt.decode(credentials.credentials, JWT_SECRET, algorithms=[JWT_ALGORITHM])
    except JWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

    role = payload.get("role", "")
    return CurrentUser(
        user_id=payload["sub"],
        email=payload.get("email", ""),
        role=role,
        permissions=ROLE_PERMISSIONS.get(role, set()),
    )


def require_permission(*permissions: str):
    required = set(permissions)

    def checker(user: Annotated[CurrentUser, Depends(get_current_user)]) -> CurrentUser:
        if not required.issubset(user.permissions):
            missing = list(required - user.permissions)
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail={"error": "forbidden", "missing": missing},
            )
        return user

    return checker


@app.get("/posts/{post_id}")
async def get_post(
    post_id: int,
    user: Annotated[CurrentUser, Depends(require_permission("posts:read"))],
):
    return {"post_id": post_id, "viewer": user.user_id}


@app.delete("/posts/{post_id}")
async def delete_post(
    post_id: int,
    user: Annotated[CurrentUser, Depends(require_permission("posts:delete"))],
):
    return {"deleted": post_id, "by": user.user_id}
