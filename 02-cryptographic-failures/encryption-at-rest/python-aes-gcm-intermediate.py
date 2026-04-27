# Feature        : Encryption at Rest — AES-256-GCM authenticated encryption
# Language       : Python 3.11
# Framework      : None — standard library + cryptography package
# Level          : Intermediate
# OWASP          : A02 — Cryptographic Failures
# Protects       : Against exposure of sensitive data from database breaches,
#                  stolen backups, or misconfigured storage
# Does NOT cover : Encryption in transit (see tls-config/), key management
#                  infrastructure (see key-management/), full-disk encryption
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, cryptography 42.0.5
# Last reviewed  : 2024-03-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# WHY AES-256-GCM
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AES-256-GCM provides two guarantees:
#   1. CONFIDENTIALITY — data cannot be read without the key
#   2. INTEGRITY       — any tampering with the ciphertext is detected
#
# The "GCM" part (Galois/Counter Mode) includes a Message Authentication
# Code (MAC) called a "tag". When you decrypt, the tag is verified first.
# If someone modified the ciphertext in storage, decryption fails loudly
# rather than silently returning corrupted data.
#
# DO NOT USE: AES-ECB (no integrity, reveals patterns in data)
#             AES-CBC without a MAC (no integrity check)
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# REPLACE THESE BEFORE USING:
#   ENCRYPTION_KEY — 32 bytes (256 bits), loaded from env or secrets manager
#                    generate: python -c "import secrets; print(secrets.token_hex(32))"
#                    Store in environment variable, NEVER in source code
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import os
import base64
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

# ── Key loading ───────────────────────────────────────────────────────────────
# The key must be exactly 32 bytes for AES-256.
# Store the hex-encoded key in your environment and decode it here.
def load_encryption_key() -> bytes:
    """
    Load and validate the encryption key from the environment.
    Raises clearly if the key is missing or the wrong length.
    """
    key_hex = os.environ.get("ENCRYPTION_KEY")
    if not key_hex:
        raise RuntimeError(
            "ENCRYPTION_KEY environment variable is not set. "
            "Generate one with: python -c \"import secrets; print(secrets.token_hex(32))\""
        )

    key = bytes.fromhex(key_hex)
    if len(key) != 32:
        raise RuntimeError(
            f"ENCRYPTION_KEY must be 32 bytes (64 hex chars). Got {len(key)} bytes."
        )
    return key


# Module-level key — loaded once at startup
ENCRYPTION_KEY = load_encryption_key()


# ── Core encryption / decryption ──────────────────────────────────────────────

def encrypt(plaintext: str) -> str:
    """
    Encrypt a string using AES-256-GCM.

    Returns a base64url-encoded string in the format:
        <nonce>.<ciphertext_with_tag>

    The nonce (12 bytes) is randomly generated for every encryption call.
    It is prepended to the ciphertext and stored alongside it — the nonce
    is not secret, but it must be unique for every encryption with the same key.

    The GCM tag (16 bytes) is automatically appended to the ciphertext
    by the cryptography library.
    """
    aesgcm = AESGCM(ENCRYPTION_KEY)

    # Generate a unique nonce for this encryption operation.
    # NEVER reuse a nonce with the same key — doing so breaks GCM security.
    nonce = os.urandom(12)  # 12 bytes = 96 bits, recommended for GCM

    # Encrypt — returns ciphertext + 16-byte authentication tag concatenated
    ciphertext = aesgcm.encrypt(nonce, plaintext.encode("utf-8"), None)

    # Encode both parts as base64url and join with a dot separator
    # This produces a single string safe to store in any text column
    encoded_nonce      = base64.urlsafe_b64encode(nonce).decode()
    encoded_ciphertext = base64.urlsafe_b64encode(ciphertext).decode()
    return f"{encoded_nonce}.{encoded_ciphertext}"


def decrypt(encrypted_value: str) -> str:
    """
    Decrypt a value produced by encrypt().

    Raises cryptography.exceptions.InvalidTag if the ciphertext has been
    tampered with or the wrong key is used — never returns corrupted data silently.
    """
    aesgcm = AESGCM(ENCRYPTION_KEY)

    try:
        encoded_nonce, encoded_ciphertext = encrypted_value.split(".", 1)
    except ValueError:
        raise ValueError(
            "Invalid encrypted value format. Expected '<nonce>.<ciphertext>'."
        )

    nonce      = base64.urlsafe_b64decode(encoded_nonce)
    ciphertext = base64.urlsafe_b64decode(encoded_ciphertext)

    # decrypt() verifies the authentication tag automatically.
    # If verification fails, InvalidTag is raised — the data was tampered with.
    plaintext_bytes = aesgcm.decrypt(nonce, ciphertext, None)
    return plaintext_bytes.decode("utf-8")


# ── Key versioning for rotation ───────────────────────────────────────────────

class VersionedEncryption:
    """
    Supports key rotation by prepending a version identifier to encrypted values.

    Format stored in DB: v{version}:{nonce_b64}.{ciphertext_b64}

    When rotating keys:
    1. Add the new key as version N+1
    2. Old records encrypted with version N continue to decrypt correctly
    3. Re-encrypt old records with the new key over time (lazy rotation)
    4. Once no records use the old version, remove it
    """

    def __init__(self, keys: dict[int, bytes]):
        """
        keys: dict mapping version int → 32-byte key bytes
        Example: {1: bytes.fromhex("old_key_hex"), 2: bytes.fromhex("new_key_hex")}
        """
        if not keys:
            raise ValueError("At least one key version is required")
        self.keys = keys
        self.current_version = max(keys.keys())

    def encrypt(self, plaintext: str) -> str:
        """Encrypts with the current (highest version) key."""
        key    = self.keys[self.current_version]
        aesgcm = AESGCM(key)
        nonce  = os.urandom(12)
        ct     = aesgcm.encrypt(nonce, plaintext.encode(), None)
        nonce_b64 = base64.urlsafe_b64encode(nonce).decode()
        ct_b64    = base64.urlsafe_b64encode(ct).decode()
        return f"v{self.current_version}:{nonce_b64}.{ct_b64}"

    def decrypt(self, encrypted_value: str) -> str:
        """Decrypts using whichever key version the value was encrypted with."""
        if not encrypted_value.startswith("v"):
            raise ValueError("Missing version prefix in encrypted value")

        version_str, payload = encrypted_value[1:].split(":", 1)
        version = int(version_str)

        if version not in self.keys:
            raise ValueError(f"No key available for version {version}")

        aesgcm     = AESGCM(self.keys[version])
        nonce_b64, ct_b64 = payload.split(".", 1)
        nonce      = base64.urlsafe_b64decode(nonce_b64)
        ciphertext = base64.urlsafe_b64decode(ct_b64)
        return aesgcm.decrypt(nonce, ciphertext, None).decode()

    def needs_rotation(self, encrypted_value: str) -> bool:
        """Returns True if this value was encrypted with an older key version."""
        version_str = encrypted_value[1:].split(":", 1)[0]
        return int(version_str) < self.current_version


# ── SQLAlchemy encrypted column type ─────────────────────────────────────────

from sqlalchemy import String
from sqlalchemy.types import TypeDecorator


class EncryptedString(TypeDecorator):
    """
    A SQLAlchemy column type that transparently encrypts on write
    and decrypts on read.

    Usage in a model:
        class User(Base):
            __tablename__ = "users"
            id                  = Column(Integer, primary_key=True)
            national_id_number  = Column(EncryptedString(512))
            # national_id_number is encrypted in the DB, plain in Python

    The column must be wide enough to hold the encrypted + encoded value.
    A 50-char plaintext produces roughly 120 chars of encrypted output.
    Use String(512) or Text for safety.
    """
    impl = String
    cache_ok = True

    def process_bind_param(self, value, dialect):
        """Called when writing to the database — encrypt the value."""
        if value is None:
            return None
        return encrypt(str(value))

    def process_result_value(self, value, dialect):
        """Called when reading from the database — decrypt the value."""
        if value is None:
            return None
        return decrypt(value)


# ── Example usage ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    # Basic encrypt / decrypt
    original  = "sensitive-national-id-123456789"
    encrypted = encrypt(original)
    decrypted = decrypt(encrypted)

    print(f"Original  : {original}")
    print(f"Encrypted : {encrypted}")
    print(f"Decrypted : {decrypted}")
    print(f"Match     : {original == decrypted}")

    # Versioned encryption
    keys = {
        1: bytes.fromhex("a" * 64),  # old key — replace with real keys
        2: bytes.fromhex("b" * 64),  # new key — replace with real keys
    }
    ve = VersionedEncryption(keys)
    enc = ve.encrypt("my-passport-number")
    print(f"\nVersioned encrypted : {enc}")
    print(f"Versioned decrypted : {ve.decrypt(enc)}")
    print(f"Needs rotation      : {ve.needs_rotation(enc)}")
