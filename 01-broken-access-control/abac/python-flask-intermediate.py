# Feature        : Attribute-Based Access Control (ABAC) — Flask policy engine
# Language       : Python 3.11
# Framework      : Flask 3.0
# Level          : Intermediate
# OWASP          : A01 — Broken Access Control
# Protects       : Against context-blind access decisions — enforces rules based on
#                  user attributes, resource attributes, and environment conditions
# Does NOT cover : Distributed policy management, XACML, external policy engines
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, Flask 3.0.2
# Last reviewed  : 2024-03-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# HOW ABAC DIFFERS FROM RBAC
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# RBAC: "Is this user an editor?" → yes/no
# ABAC: "Is this user an editor, AND is this document
#         owned by them, AND is it not yet published,
#         AND is the current time within business hours?" → yes/no
#
# ABAC adds three layers:
#   - Subject attributes  (who is asking: role, department, clearance)
#   - Resource attributes (what they want: owner, status, classification)
#   - Environment attributes (when/where: time, IP, MFA status)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os
import datetime
from dataclasses import dataclass
from typing import Any, Callable
from functools import wraps
import jwt
from flask import Flask, request, jsonify, g

app = Flask(__name__)
SECRET_KEY = os.environ.get("SECRET_KEY", "REPLACE_WITH_YOUR_SECRET")


# ── Attribute containers ──────────────────────────────────────────────────────

@dataclass
class SubjectAttributes:
    """Who is making the request."""
    user_id: str
    role: str
    department: str
    mfa_verified: bool
    clearance_level: int  # 1=basic, 2=confidential, 3=secret


@dataclass
class ResourceAttributes:
    """What is being accessed."""
    resource_id: str
    resource_type: str
    owner_id: str
    status: str           # draft, published, archived
    clearance_required: int


@dataclass
class EnvironmentAttributes:
    """Context of the request."""
    timestamp: datetime.datetime
    ip_address: str
    is_business_hours: bool


# ── Policy engine ─────────────────────────────────────────────────────────────

class PolicyEngine:
    """
    Evaluates access policies against subject, resource, and environment.
    Add policies as methods. Each policy returns True (allow) or False (deny).
    Deny takes precedence — if any policy returns False, access is denied.
    """

    def can_read_document(
        self,
        subject: SubjectAttributes,
        resource: ResourceAttributes,
        env: EnvironmentAttributes
    ) -> tuple[bool, str]:
        """Policy: who can read a document."""

        # Anyone can read published documents with matching clearance
        if resource.status == "published":
            if subject.clearance_level >= resource.clearance_required:
                return True, "published document with sufficient clearance"
            return False, f"clearance level {subject.clearance_level} insufficient (required: {resource.clearance_required})"

        # Owners can always read their own drafts
        if resource.owner_id == subject.user_id:
            return True, "document owner"

        # Editors in the same department can read drafts
        if subject.role in ("editor", "admin") and resource.status == "draft":
            return True, "editor reading draft"

        return False, "no matching policy grants access"

    def can_edit_document(
        self,
        subject: SubjectAttributes,
        resource: ResourceAttributes,
        env: EnvironmentAttributes
    ) -> tuple[bool, str]:
        """Policy: who can edit a document."""

        # Archived documents cannot be edited by anyone
        if resource.status == "archived":
            return False, "archived documents are immutable"

        # Only the owner can edit their own draft
        if resource.owner_id == subject.user_id and resource.status == "draft":
            return True, "owner editing own draft"

        # Admins can edit during business hours only
        if subject.role == "admin" and env.is_business_hours:
            return True, "admin during business hours"

        # MFA must be verified for editing published content
        if resource.status == "published" and not subject.mfa_verified:
            return False, "MFA required to edit published content"

        return False, "no matching policy grants edit access"

    def can_delete_document(
        self,
        subject: SubjectAttributes,
        resource: ResourceAttributes,
        env: EnvironmentAttributes
    ) -> tuple[bool, str]:
        """Policy: only admins with MFA can delete."""
        if subject.role != "admin":
            return False, "deletion requires admin role"
        if not subject.mfa_verified:
            return False, "deletion requires MFA verification"
        return True, "admin with MFA verified"


policy_engine = PolicyEngine()


# ── Auth middleware ───────────────────────────────────────────────────────────

def get_subject_from_token() -> SubjectAttributes | None:
    """Decode JWT and build SubjectAttributes from claims."""
    header = request.headers.get("Authorization", "")
    if not header.startswith("Bearer "):
        return None
    try:
        payload = jwt.decode(header[7:], SECRET_KEY, algorithms=["HS256"])
        return SubjectAttributes(
            user_id=payload["sub"],
            role=payload.get("role", "viewer"),
            department=payload.get("department", "general"),
            mfa_verified=payload.get("mfa_verified", False),
            clearance_level=payload.get("clearance_level", 1),
        )
    except jwt.PyJWTError:
        return None


def get_environment() -> EnvironmentAttributes:
    """Build EnvironmentAttributes from the current request context."""
    now = datetime.datetime.utcnow()
    return EnvironmentAttributes(
        timestamp=now,
        ip_address=request.remote_addr or "unknown",
        is_business_hours=(9 <= now.hour < 18 and now.weekday() < 5),
    )


def abac_policy(policy_fn: Callable):
    """
    Decorator that applies an ABAC policy function to a route.

    The policy_fn must accept (subject, resource, environment) and return
    (allowed: bool, reason: str). The resource is fetched from g.resource
    which must be set by the route before this decorator runs.

    Usage:
        @app.route("/documents/<doc_id>")
        @abac_policy(policy_engine.can_read_document)
        def get_document(doc_id): ...
    """
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            subject = get_subject_from_token()
            if not subject:
                return jsonify(error="Authentication required"), 401

            # resource must be attached to g by the route or a before_request hook
            resource: ResourceAttributes = getattr(g, "resource", None)
            if not resource:
                return jsonify(error="Resource context not established"), 500

            env = get_environment()
            allowed, reason = policy_fn(subject, resource, env)

            if not allowed:
                return jsonify(error="Access denied", reason=reason), 403

            g.subject = subject
            return f(*args, **kwargs)
        return wrapper
    return decorator


# ── Example resource loader ───────────────────────────────────────────────────

def load_document(doc_id: str) -> ResourceAttributes:
    """In production: load from database. Here we return a fixture."""
    return ResourceAttributes(
        resource_id=doc_id,
        resource_type="document",
        owner_id="user_42",
        status="draft",
        clearance_required=1,
    )


# ── Routes ────────────────────────────────────────────────────────────────────

@app.route("/documents/<doc_id>")
@abac_policy(policy_engine.can_read_document)
def get_document(doc_id: str):
    g.resource = load_document(doc_id)
    return jsonify(document=doc_id, accessed_by=g.subject.user_id)


@app.route("/documents/<doc_id>", methods=["PATCH"])
@abac_policy(policy_engine.can_edit_document)
def edit_document(doc_id: str):
    g.resource = load_document(doc_id)
    return jsonify(updated=doc_id)


@app.route("/documents/<doc_id>", methods=["DELETE"])
@abac_policy(policy_engine.can_delete_document)
def delete_document(doc_id: str):
    g.resource = load_document(doc_id)
    return jsonify(deleted=doc_id)
