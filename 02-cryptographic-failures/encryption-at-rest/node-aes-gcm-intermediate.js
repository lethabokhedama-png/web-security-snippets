// Feature        : Encryption at Rest — AES-256-GCM authenticated encryption
// Language       : JavaScript (Node.js 20)
// Framework      : None — Node.js built-in crypto module
// Level          : Intermediate
// OWASP          : A02 — Cryptographic Failures
// Protects       : Against data exposure from database breaches or stolen backups
// Does NOT cover : Key management infrastructure, in-transit encryption, full-disk encryption
// Dependencies   : See package.json (crypto is built into Node.js — no install needed)
// Tested on      : Node.js 20.11.1
// Last reviewed  : 2024-03-01

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// REPLACE THESE BEFORE USING:
//   ENCRYPTION_KEY — 32 bytes as a 64-char hex string in process.env.ENCRYPTION_KEY
//                    generate: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

'use strict';
const crypto = require('crypto');

const ALGORITHM  = 'aes-256-gcm';
const KEY_BYTES  = 32;   // 256 bits
const NONCE_BYTES = 12;  // 96 bits — recommended for GCM
const TAG_BYTES  = 16;   // GCM authentication tag length

// ── Key loading ───────────────────────────────────────────────────────────────

function loadEncryptionKey() {
  const keyHex = process.env.ENCRYPTION_KEY;
  if (!keyHex) {
    throw new Error(
      'ENCRYPTION_KEY environment variable is not set.\n' +
      'Generate one with: node -e "console.log(require(\'crypto\').randomBytes(32).toString(\'hex\'))"'
    );
  }
  const key = Buffer.from(keyHex, 'hex');
  if (key.length !== KEY_BYTES) {
    throw new Error(`ENCRYPTION_KEY must be ${KEY_BYTES} bytes (${KEY_BYTES * 2} hex chars). Got ${key.length} bytes.`);
  }
  return key;
}

const ENCRYPTION_KEY = loadEncryptionKey();

// ── Core encrypt / decrypt ────────────────────────────────────────────────────

/**
 * Encrypt a string using AES-256-GCM.
 *
 * Returns a base64url string in the format:
 *   <nonce_b64url>.<ciphertext_b64url>.<tag_b64url>
 *
 * The nonce is randomly generated per encryption call.
 * The GCM tag is stored to verify integrity on decryption.
 *
 * @param {string} plaintext  The sensitive string to encrypt
 * @returns {string}          The encrypted value safe to store in any text column
 */
function encrypt(plaintext) {
  // New random nonce for every call — NEVER reuse a nonce with the same key
  const nonce  = crypto.randomBytes(NONCE_BYTES);
  const cipher = crypto.createCipheriv(ALGORITHM, ENCRYPTION_KEY, nonce, { authTagLength: TAG_BYTES });

  const encrypted = Buffer.concat([
    cipher.update(plaintext, 'utf8'),
    cipher.final(),
  ]);

  // The auth tag must be retrieved AFTER calling cipher.final()
  const tag = cipher.getAuthTag();

  const noncePart  = nonce.toString('base64url');
  const cipherPart = encrypted.toString('base64url');
  const tagPart    = tag.toString('base64url');

  return `${noncePart}.${cipherPart}.${tagPart}`;
}

/**
 * Decrypt a value produced by encrypt().
 *
 * Verifies the GCM authentication tag before returning plaintext.
 * Throws if the ciphertext has been tampered with or the key is wrong.
 *
 * @param {string} encryptedValue  The value returned by encrypt()
 * @returns {string}               The original plaintext
 */
function decrypt(encryptedValue) {
  const parts = encryptedValue.split('.');
  if (parts.length !== 3) {
    throw new Error('Invalid encrypted value format. Expected "<nonce>.<ciphertext>.<tag>".');
  }

  const [noncePart, cipherPart, tagPart] = parts;
  const nonce      = Buffer.from(noncePart,  'base64url');
  const ciphertext = Buffer.from(cipherPart, 'base64url');
  const tag        = Buffer.from(tagPart,    'base64url');

  const decipher = crypto.createDecipheriv(ALGORITHM, ENCRYPTION_KEY, nonce, { authTagLength: TAG_BYTES });

  // Set the tag BEFORE calling decipher.final() — this is what enables integrity verification
  decipher.setAuthTag(tag);

  try {
    const plaintext = Buffer.concat([
      decipher.update(ciphertext),
      decipher.final(),  // throws if the auth tag does not match
    ]);
    return plaintext.toString('utf8');
  } catch (err) {
    // Do not leak whether the failure was key mismatch or tampering
    throw new Error('Decryption failed. Data may have been tampered with or the key is incorrect.');
  }
}

// ── Key versioning for rotation ───────────────────────────────────────────────

class VersionedEncryption {
  /**
   * @param {Object.<number, Buffer>} keys  Map of version number → 32-byte key Buffer
   * @example
   *   const ve = new VersionedEncryption({
   *     1: Buffer.from('oldKeyHex', 'hex'),
   *     2: Buffer.from('newKeyHex', 'hex'),
   *   });
   */
  constructor(keys) {
    if (!keys || Object.keys(keys).length === 0) {
      throw new Error('At least one key version required');
    }
    this.keys = keys;
    this.currentVersion = Math.max(...Object.keys(keys).map(Number));
  }

  encrypt(plaintext) {
    const key    = this.keys[this.currentVersion];
    const nonce  = crypto.randomBytes(NONCE_BYTES);
    const cipher = crypto.createCipheriv(ALGORITHM, key, nonce, { authTagLength: TAG_BYTES });
    const ct     = Buffer.concat([cipher.update(plaintext, 'utf8'), cipher.final()]);
    const tag    = cipher.getAuthTag();
    return `v${this.currentVersion}:${nonce.toString('base64url')}.${ct.toString('base64url')}.${tag.toString('base64url')}`;
  }

  decrypt(encryptedValue) {
    const colonIdx  = encryptedValue.indexOf(':');
    const version   = parseInt(encryptedValue.slice(1, colonIdx), 10);
    const key       = this.keys[version];
    if (!key) throw new Error(`No key for version ${version}`);

    const [noncePart, cipherPart, tagPart] = encryptedValue.slice(colonIdx + 1).split('.');
    const nonce    = Buffer.from(noncePart,  'base64url');
    const ciphertext = Buffer.from(cipherPart, 'base64url');
    const tag      = Buffer.from(tagPart,    'base64url');

    const decipher = crypto.createDecipheriv(ALGORITHM, key, nonce, { authTagLength: TAG_BYTES });
    decipher.setAuthTag(tag);
    return Buffer.concat([decipher.update(ciphertext), decipher.final()]).toString('utf8');
  }

  needsRotation(encryptedValue) {
    const version = parseInt(encryptedValue.slice(1, encryptedValue.indexOf(':')), 10);
    return version < this.currentVersion;
  }
}

// ── Prisma / ORM integration helper ──────────────────────────────────────────

/**
 * encryptFields / decryptFields
 *
 * Helper pair for use with ORMs that do not support custom column types.
 * Encrypt before save, decrypt after read.
 *
 * Usage with Prisma:
 *   const data  = encryptFields({ nationalId: '123456789', email: 'user@example.com' }, ['nationalId']);
 *   await prisma.user.create({ data });
 *
 *   const raw   = await prisma.user.findUnique({ where: { id } });
 *   const user  = decryptFields(raw, ['nationalId']);
 */
function encryptFields(obj, fields) {
  const result = { ...obj };
  for (const field of fields) {
    if (result[field] != null) {
      result[field] = encrypt(String(result[field]));
    }
  }
  return result;
}

function decryptFields(obj, fields) {
  if (!obj) return obj;
  const result = { ...obj };
  for (const field of fields) {
    if (result[field] != null) {
      result[field] = decrypt(result[field]);
    }
  }
  return result;
}

module.exports = { encrypt, decrypt, VersionedEncryption, encryptFields, decryptFields };
