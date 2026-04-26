# Feature        : Role-Based Access Control (RBAC) — Permission-scoped middleware
# Language       : Python 3.11
# Framework      : Flask 3.0
# Level          : Advanced
# OWASP          : A01 — Broken Access Control
# Protects       : Fine-grained permission enforcement, role hierarchy, audit trail
# Does NOT cover : Attribute-based rules, field-level filtering
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, Flask 3.0.3, PyJWT 2.8.0
# Last reviewed  : 2024-06-01

import os
import logging
from dataclasses import dataclass
from functools import wraps
from typing import FrozenSet

import jwt
from flask import Flask, g, jsonify, request

app = Flask(__name__)
logger = logging.getLogger(__name__)

JWT_SECRET    = os.environ["JWT_SECRET_KEY"]
JWT_ALGORITHM = "HS256"

# ── PERMISSION MODEL ──────────────────────────────────────
@dataclass(frozen=True)
class Permission:
    resource: str
    action: str

    def __str__(self):
        return f"{self.resource}:{self.action}"


PERMISSIONS = {
    "posts:read":    Permission("posts", "read"),
    "posts:write":   Permission("posts", "write"),
    "posts:delete":  Permission("posts", "delete"),
    "users:read":    Permission("users", "read"),
    "users:write":   Permission("users", "write"),
    "users:delete":  Permission("users", "delete"),
    "billing:read":  Permission("billing", "read"),
    "billing:write": Permission("billing", "write"),
}

ROLE_PERMISSIONS: dict[str, FrozenSet[Permission]] = {
    "viewer": frozenset({
        PERMISSIONS["posts:read"],
    }),
    "editor": frozenset({
        PERMISSIONS["posts:read"],
        PERMISSIONS["posts:write"],
    }),
    "moderator": frozenset({
        PERMISSIONS["posts:read"],
        PERMISSIONS["posts:write"],
        PERMISSIONS["posts:delete"],
        PERMISSIONS["users:read"],
    }),
    "billing_admin": frozenset({
        PERMISSIONS["billing:read"],
        PERMISSIONS["billing:write"],
    }),
    "admin": frozenset(PERMISSIONS.values()),
}


def _extract_and_verify_token() -> dict:
    auth = request.headers.get("Authorization", "")
    if not auth.startswith("Bearer "):
        raise PermissionError("missing_token")
    token = auth.split(" ", 1)[1]
    try:
        return jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
    except jwt.ExpiredSignatureError:
        raise PermissionError("expired_token")
    except jwt.InvalidTokenError:
        raise PermissionError("invalid_token")


def require_permission(*required: str):
    required_set = frozenset(PERMISSIONS[p] for p in required if p in PERMISSIONS)

    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            try:
                payload = _extract_and_verify_token()
            except PermissionError as e:
                return jsonify({"error": str(e)}), 401

            role = payload.get("role", "")
            granted = ROLE_PERMISSIONS.get(role, frozenset())

            if not required_set.issubset(granted):
                missing = [str(p) for p in required_set - granted]
                logger.warning(
                    "access_denied user=%s role=%s missing=%s path=%s",
                    payload.get("sub"), role, missing, request.path
                )
                return jsonify({"error": "forbidden", "missing": missing}), 403

            g.current_user = {
                "user_id": payload["sub"],
                "role": role,
                "permissions": [str(p) for p in granted],
            }
            return f(*args, **kwargs)
        return wrapper
    return decorator


@app.route("/posts/<int:post_id>", methods=["DELETE"])
@require_permission("posts:delete")
def delete_post(post_id: int):
    return jsonify({"deleted": post_id, "by": g.current_user["user_id"]})


@app.route("/billing/invoices", methods=["GET"])
@require_permission("billing:read")
def list_invoices():
    return jsonify({"invoices": []})
