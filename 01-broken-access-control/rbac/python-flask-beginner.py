# Feature        : Role-Based Access Control (RBAC) — Route Protection
# Language       : Python 3.11
# Framework      : Flask 3.0
# Level          : Beginner
# OWASP          : A01 — Broken Access Control
# Protects       : Against unauthorised users accessing routes above their permission level
# Does NOT cover : Attribute-based rules, row-level data filtering, MFA
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, Flask 3.0.3, PyJWT 2.8.0
# Last reviewed  : 2024-06-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# HOW THIS WORKS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 1. A user logs in and receives a JWT token that contains their role
# 2. Every protected route is decorated with @require_role(...)
# 3. The decorator checks the token on every request before the
#    route handler runs — the handler only runs if the role matches
# 4. If the role does not match, the user gets a 403 Forbidden response
#    and the route handler never executes
#
# WHY THIS MATTERS
# Without access control, any logged-in user can call any route —
# including admin endpoints. This is the #1 vulnerability class
# in web applications. The fix is a decorator that runs on every
# request before your business logic does.
#
# REPLACE THESE VALUES:
#   YOUR_JWT_SECRET_KEY → a long random string, kept in an env variable
#                         never hardcode a real secret in source code
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os
from functools import wraps

import jwt  # PyJWT — install via requirements.txt
from flask import Flask, jsonify, request

app = Flask(__name__)

# ── CONFIGURATION ─────────────────────────────────────────
# Load your secret from an environment variable, never from code.
# To set it locally: export JWT_SECRET_KEY="your-long-random-string"
JWT_SECRET = os.environ.get("JWT_SECRET_KEY", "REPLACE_WITH_ENV_VAR")
JWT_ALGORITHM = "HS256"

# ── ROLE HIERARCHY ────────────────────────────────────────
# Define which roles exist in your system and their rank.
# A higher number means more permissions.
# This lets us check "does this user have at least editor access?"
# without listing every permitted role explicitly.
ROLE_HIERARCHY = {
    "viewer": 1,   # can only read content
    "editor": 2,   # can read and write content
    "admin":  3,   # can do everything
}


# ── THE DECORATOR ─────────────────────────────────────────
def require_role(minimum_role: str):
    """
    Decorator that protects a Flask route by role.

    Usage:
        @app.route("/admin/dashboard")
        @require_role("admin")
        def admin_dashboard():
            ...

    How it works:
        1. Extracts the JWT from the Authorization header
        2. Verifies the JWT signature using your secret key
        3. Reads the 'role' claim from the token payload
        4. Checks that the role meets the minimum required level
        5. If all checks pass, the route handler runs
        6. If any check fails, returns 401 or 403 immediately
    """
    def decorator(f):
        @wraps(f)  # preserves the original function name for Flask routing
        def protected_route(*args, **kwargs):

            # ── Step 1: Get the token from the Authorization header
            # The header format is: "Authorization: Bearer <token>"
            auth_header = request.headers.get("Authorization", "")

            if not auth_header.startswith("Bearer "):
                # No token provided at all — user is not authenticated
                return jsonify({"error": "Authentication required"}), 401

            # Extract just the token part (everything after "Bearer ")
            token = auth_header.split(" ", 1)[1]

            # ── Step 2: Verify and decode the token
            try:
                payload = jwt.decode(
                    token,
                    JWT_SECRET,
                    algorithms=[JWT_ALGORITHM]
                    # PyJWT automatically checks the expiry (exp) claim
                    # and raises ExpiredSignatureError if the token is expired
                )
            except jwt.ExpiredSignatureError:
                # Token was valid but has expired — user must log in again
                return jsonify({"error": "Token has expired"}), 401
            except jwt.InvalidTokenError:
                # Token signature is wrong or token is malformed
                # This means someone tampered with the token or it is fake
                return jsonify({"error": "Invalid token"}), 401

            # ── Step 3: Check the role claim
            user_role = payload.get("role")

            if user_role not in ROLE_HIERARCHY:
                # The token contains a role that does not exist in our system
                return jsonify({"error": "Invalid role in token"}), 403

            # ── Step 4: Check the role meets the minimum required level
            # Example: route requires "editor" (level 2)
            #   user has "admin" (level 3) → 3 >= 2 → allowed
            #   user has "viewer" (level 1) → 1 >= 2 → denied
            if ROLE_HIERARCHY[user_role] < ROLE_HIERARCHY[minimum_role]:
                return jsonify({
                    "error": "Insufficient permissions",
                    "required": minimum_role,
                    "yours": user_role
                }), 403

            # ── Step 5: Attach user info to the request context
            # This lets route handlers access the current user's data
            # without decoding the token themselves
            request.current_user = {
                "user_id": payload.get("sub"),
                "role": user_role,
                "email": payload.get("email"),
            }

            # All checks passed — run the actual route handler
            return f(*args, **kwargs)

        return protected_route
    return decorator


# ── EXAMPLE ROUTES ────────────────────────────────────────
# These show how to use the decorator on your actual routes.
# Any authenticated user can access viewer routes.
# Only editors and admins can access editor routes.
# Only admins can access admin routes.

@app.route("/content", methods=["GET"])
@require_role("viewer")
def get_content():
    # request.current_user is set by the decorator above
    return jsonify({
        "message": "Here is the content",
        "requested_by": request.current_user["email"]
    })


@app.route("/content", methods=["POST"])
@require_role("editor")
def create_content():
    return jsonify({"message": "Content created"})


@app.route("/admin/users", methods=["GET"])
@require_role("admin")
def list_users():
    # Only admins reach this point
    return jsonify({"message": "Admin-only user list"})


# ── HELPER: GENERATE A TEST TOKEN ─────────────────────────
# This is only for testing. In production, tokens are issued
# by your login endpoint after verifying username and password.
import datetime

def generate_token(user_id: int, email: str, role: str) -> str:
    """
    Creates a JWT token with the user's role embedded.
    Call this from your login route after verifying credentials.
    """
    payload = {
        "sub": user_id,           # subject — the user's ID
        "email": email,           # user's email for convenience
        "role": role,             # the role that controls access
        "iat": datetime.datetime.utcnow(),  # issued at
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1),  # expires in 1 hour
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


# ── USAGE EXAMPLE ─────────────────────────────────────────
# To test this locally:
#
#   1. Start the app: python python-flask-beginner.py
#   2. Generate a token:
#      token = generate_token(1, "alice@example.com", "admin")
#
#   3. Make a request:
#      curl -H "Authorization: Bearer <token>" http://localhost:5000/admin/users
#
#   4. Try with a viewer token and verify you get 403 on the admin route

if __name__ == "__main__":
    app.run(debug=False)  # never use debug=True in production
