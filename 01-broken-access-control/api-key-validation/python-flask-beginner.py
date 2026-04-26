# Feature        : API Key Validation — Generation, hashing, and verification
# Language       : Python 3.11
# Framework      : Flask 3.0
# Level          : Beginner
# OWASP          : A01 — Broken Access Control
# Protects       : Against unauthorised API access; protects keys from storage compromise
# Does NOT cover : Key scoping, per-endpoint permissions, key rotation UI
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, Flask 3.0.2
# Last reviewed  : 2024-03-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WHY WE HASH API KEYS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# If you store API keys in plain text in your database,
# a database breach = all client keys compromised immediately.
#
# We hash the key using HMAC-SHA256 with a server-side secret
# before storing it. The client sends the raw key in requests.
# We hash it on arrival and compare it to the stored hash.
# Even with database access, an attacker cannot reverse the hash.
#
# REPLACE THESE BEFORE USING:
#   HMAC_SECRET  → a 32+ character random string stored in env
#                  generate: python -c "import secrets; print(secrets.token_hex(32))"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os
import hmac
import hashlib
import secrets
from functools import wraps
from flask import Flask, request, jsonify

app = Flask(__name__)

# Load from environment — never hardcode
HMAC_SECRET = os.environ.get("HMAC_SECRET", "REPLACE_WITH_YOUR_HMAC_SECRET").encode()

# In production: use a real database. This dict simulates one.
# key_hash → { "client_id": ..., "scopes": [...], "active": bool }
API_KEY_STORE: dict[str, dict] = {}


def generate_api_key() -> str:
    """
    Generate a cryptographically secure API key.
    32 bytes = 256 bits of randomness — computationally infeasible to guess.
    Returns a URL-safe string the client will store and send with requests.
    """
    return secrets.token_urlsafe(32)


def hash_api_key(raw_key: str) -> str:
    """
    Hash an API key using HMAC-SHA256 before storing it.
    HMAC uses the server-side secret so the hash cannot be computed
    without it — even if an attacker knows the algorithm.
    Returns a hex string safe to store in the database.
    """
    return hmac.new(HMAC_SECRET, raw_key.encode(), hashlib.sha256).hexdigest()


def validate_api_key(raw_key: str) -> dict | None:
    """
    Hash the incoming key and look it up in the store.
    Returns the key record if found and active, otherwise None.
    Uses hmac.compare_digest for constant-time comparison
    to prevent timing attacks.
    """
    expected_hash = hash_api_key(raw_key)

    for stored_hash, record in API_KEY_STORE.items():
        # constant-time comparison — prevents timing side channel attacks
        if hmac.compare_digest(stored_hash, expected_hash):
            if not record.get("active", False):
                return None  # key exists but has been revoked
            return record

    return None  # key not found


def require_api_key(scopes: list[str] | None = None):
    """
    Decorator that protects a route with API key authentication.

    Checks:
      1. The X-API-Key header is present
      2. The key exists in the store and is active
      3. The key has the required scopes (if specified)

    Usage:
        @app.route("/data")
        @require_api_key(scopes=["read:data"])
        def get_data(): ...
    """
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            # Keys must be in the X-API-Key header — never in query strings
            # Query string parameters appear in server logs and browser history
            raw_key = request.headers.get("X-API-Key")
            if not raw_key:
                return jsonify({"error": "API key required. Use X-API-Key header."}), 401

            record = validate_api_key(raw_key)
            if not record:
                return jsonify({"error": "Invalid or revoked API key."}), 401

            # Check that this key has the required scopes
            if scopes:
                key_scopes = record.get("scopes", [])
                missing = [s for s in scopes if s not in key_scopes]
                if missing:
                    return jsonify({
                        "error": "Insufficient scope.",
                        "required": scopes,
                        "missing": missing
                    }), 403

            # Attach the record to the request for use in route handlers
            request.api_client = record
            return f(*args, **kwargs)
        return wrapper
    return decorator


# ── Key management endpoints ──────────────────────────────────────────────────

@app.route("/api-keys", methods=["POST"])
def create_api_key():
    """
    Issues a new API key for a client.
    In production: require authentication (admin or the client themselves).
    """
    data = request.get_json() or {}
    client_id = data.get("client_id")
    scopes    = data.get("scopes", ["read:data"])

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400

    # Generate the raw key — this is shown ONCE and never again
    raw_key = generate_api_key()
    key_hash = hash_api_key(raw_key)

    # Store only the hash
    API_KEY_STORE[key_hash] = {
        "client_id": client_id,
        "scopes": scopes,
        "active": True,
    }

    return jsonify({
        "api_key": raw_key,  # shown once — client must save this
        "client_id": client_id,
        "scopes": scopes,
        "warning": "Store this key securely. It will not be shown again."
    }), 201


@app.route("/api-keys/<client_id>", methods=["DELETE"])
def revoke_api_key(client_id: str):
    """Revoke all keys for a given client."""
    revoked = 0
    for record in API_KEY_STORE.values():
        if record.get("client_id") == client_id and record.get("active"):
            record["active"] = False
            revoked += 1
    return jsonify({"revoked": revoked, "client_id": client_id})


# ── Protected endpoints ───────────────────────────────────────────────────────

@app.route("/api/data")
@require_api_key(scopes=["read:data"])
def get_data():
    return jsonify({"data": [1, 2, 3], "client": request.api_client["client_id"]})


@app.route("/api/data", methods=["POST"])
@require_api_key(scopes=["write:data"])
def post_data():
    return jsonify({"created": True, "client": request.api_client["client_id"]})


if __name__ == "__main__":
    app.run(debug=False)
