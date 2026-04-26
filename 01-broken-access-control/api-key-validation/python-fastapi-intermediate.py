# Feature        : API Key Validation — FastAPI dependency injection
# Language       : Python 3.11
# Framework      : FastAPI 0.110
# Level          : Intermediate
# OWASP          : A01 — Broken Access Control
# Protects       : Against unauthorised API access with HMAC-hashed key storage
# Does NOT cover : Key rotation UI, per-route granular scopes beyond listed
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, FastAPI 0.110.0
# Last reviewed  : 2024-03-01

import os, hmac, hashlib, secrets
from typing import Annotated
from fastapi import FastAPI, Depends, HTTPException, Security, status
from fastapi.security import APIKeyHeader
from pydantic import BaseModel

app        = FastAPI()
HMAC_SECRET = os.environ.get("HMAC_SECRET", "").encode()
api_key_header = APIKeyHeader(name="X-API-Key", auto_error=True)

# Simulated DB — replace with actual DB lookups
API_KEY_STORE: dict[str, dict] = {}


def _hash(raw: str) -> str:
    return hmac.new(HMAC_SECRET, raw.encode(), hashlib.sha256).hexdigest()

def _lookup(raw: str) -> dict | None:
    h = _hash(raw)
    for stored, record in API_KEY_STORE.items():
        if hmac.compare_digest(stored, h) and record.get("active"):
            return record
    return None


class APIKeyRecord(BaseModel):
    client_id: str
    scopes: list[str]


def get_api_client(key: str = Security(api_key_header)) -> APIKeyRecord:
    record = _lookup(key)
    if not record:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid API key")
    return APIKeyRecord(**record)


def require_scope(*scopes: str):
    def dependency(client: Annotated[APIKeyRecord, Depends(get_api_client)]) -> APIKeyRecord:
        missing = [s for s in scopes if s not in client.scopes]
        if missing:
            raise HTTPException(status_code=403, detail=f"Missing scopes: {missing}")
        return client
    return dependency


class KeyRequest(BaseModel):
    client_id: str
    scopes: list[str] = ["read:data"]


@app.post("/api-keys", status_code=201)
def create_key(body: KeyRequest):
    raw = secrets.token_urlsafe(32)
    API_KEY_STORE[_hash(raw)] = {"client_id": body.client_id, "scopes": body.scopes, "active": True}
    return {"api_key": raw, "warning": "Store securely. Not shown again."}


@app.get("/api/data")
def get_data(client: Annotated[APIKeyRecord, Depends(require_scope("read:data"))]):
    return {"data": [], "client": client.client_id}


@app.post("/api/data")
def post_data(client: Annotated[APIKeyRecord, Depends(require_scope("write:data"))]):
    return {"created": True, "client": client.client_id}
