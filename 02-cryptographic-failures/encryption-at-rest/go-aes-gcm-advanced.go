// Feature        : Encryption at Rest — AES-256-GCM authenticated encryption
// Language       : Go 1.22
// Framework      : None — Go standard library crypto/aes and crypto/cipher
// Level          : Advanced
// OWASP          : A02 — Cryptographic Failures
// Protects       : Against data exposure from database breaches or stolen backups
// Does NOT cover : Key management infrastructure, transit encryption, key HSM integration
// Dependencies   : See go.mod (standard library only — no external deps)
// Tested on      : Go 1.22
// Last reviewed  : 2024-03-01

package encryption

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

const (
	keySize   = 32 // AES-256
	nonceSize = 12 // 96-bit nonce — recommended for GCM
)

// ── Key loading ───────────────────────────────────────────────────────────────

// LoadKeyFromEnv reads ENCRYPTION_KEY from the environment and validates it.
// The env var must be a 64-character hex string (32 bytes / 256 bits).
func LoadKeyFromEnv() ([]byte, error) {
	hexKey := os.Getenv("ENCRYPTION_KEY")
	if hexKey == "" {
		return nil, errors.New("ENCRYPTION_KEY environment variable is not set")
	}
	key := make([]byte, keySize)
	n, err := fmt.Sscanf(hexKey, "%x", &key)
	if err != nil || n != 1 || len(key) != keySize {
		return nil, fmt.Errorf("ENCRYPTION_KEY must be %d bytes (%d hex chars)", keySize, keySize*2)
	}
	return key, nil
}

// ── Core Encryptor ────────────────────────────────────────────────────────────

// Encryptor holds a key and provides Encrypt/Decrypt methods.
type Encryptor struct {
	key []byte
}

// NewEncryptor creates an Encryptor with the given 32-byte key.
func NewEncryptor(key []byte) (*Encryptor, error) {
	if len(key) != keySize {
		return nil, fmt.Errorf("key must be %d bytes, got %d", keySize, len(key))
	}
	keyCopy := make([]byte, keySize)
	copy(keyCopy, key)
	return &Encryptor{key: keyCopy}, nil
}

// Encrypt encrypts plaintext using AES-256-GCM.
// Returns a base64url string: <nonce>.<ciphertext_with_tag>
// The nonce is randomly generated per call — must never be reused with the same key.
func (e *Encryptor) Encrypt(plaintext string) (string, error) {
	block, err := aes.NewCipher(e.key)
	if err != nil {
		return "", fmt.Errorf("creating cipher: %w", err)
	}

	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", fmt.Errorf("creating GCM: %w", err)
	}

	nonce := make([]byte, nonceSize)
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return "", fmt.Errorf("generating nonce: %w", err)
	}

	// Seal appends the ciphertext and the GCM authentication tag to dst.
	// nonce is used as a prefix source, not prepended automatically.
	ciphertext := gcm.Seal(nil, nonce, []byte(plaintext), nil)

	noncePart := base64.RawURLEncoding.EncodeToString(nonce)
	ctPart    := base64.RawURLEncoding.EncodeToString(ciphertext)
	return noncePart + "." + ctPart, nil
}

// Decrypt decrypts a value produced by Encrypt.
// Returns an error if the ciphertext is tampered with or the key is wrong.
func (e *Encryptor) Decrypt(encryptedValue string) (string, error) {
	parts := strings.SplitN(encryptedValue, ".", 2)
	if len(parts) != 2 {
		return "", errors.New("invalid encrypted value: expected '<nonce>.<ciphertext>'")
	}

	nonce, err := base64.RawURLEncoding.DecodeString(parts[0])
	if err != nil {
		return "", fmt.Errorf("decoding nonce: %w", err)
	}
	ciphertext, err := base64.RawURLEncoding.DecodeString(parts[1])
	if err != nil {
		return "", fmt.Errorf("decoding ciphertext: %w", err)
	}

	block, err := aes.NewCipher(e.key)
	if err != nil {
		return "", fmt.Errorf("creating cipher: %w", err)
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", fmt.Errorf("creating GCM: %w", err)
	}

	// Open verifies the GCM tag and decrypts. Returns an error if tampered.
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return "", errors.New("decryption failed: ciphertext may be tampered or key is incorrect")
	}
	return string(plaintext), nil
}

// ── Versioned key rotation ────────────────────────────────────────────────────

// VersionedEncryptor supports key rotation with versioned ciphertext.
// Stored format: v{version}:{nonce_b64url}.{ciphertext_b64url}
type VersionedEncryptor struct {
	encryptors     map[int]*Encryptor
	currentVersion int
}

// NewVersionedEncryptor creates an encryptor supporting multiple key versions.
// keys maps version number → 32-byte key. The highest version is used for encryption.
func NewVersionedEncryptor(keys map[int][]byte) (*VersionedEncryptor, error) {
	if len(keys) == 0 {
		return nil, errors.New("at least one key version required")
	}
	ve := &VersionedEncryptor{encryptors: make(map[int]*Encryptor)}
	for v, key := range keys {
		enc, err := NewEncryptor(key)
		if err != nil {
			return nil, fmt.Errorf("version %d: %w", v, err)
		}
		ve.encryptors[v] = enc
		if v > ve.currentVersion {
			ve.currentVersion = v
		}
	}
	return ve, nil
}

func (ve *VersionedEncryptor) Encrypt(plaintext string) (string, error) {
	enc := ve.encryptors[ve.currentVersion]
	inner, err := enc.Encrypt(plaintext)
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("v%d:%s", ve.currentVersion, inner), nil
}

func (ve *VersionedEncryptor) Decrypt(encryptedValue string) (string, error) {
	if !strings.HasPrefix(encryptedValue, "v") {
		return "", errors.New("missing version prefix")
	}
	colonIdx := strings.Index(encryptedValue, ":")
	if colonIdx < 0 {
		return "", errors.New("missing version separator")
	}
	version, err := strconv.Atoi(encryptedValue[1:colonIdx])
	if err != nil {
		return "", fmt.Errorf("invalid version: %w", err)
	}
	enc, ok := ve.encryptors[version]
	if !ok {
		return "", fmt.Errorf("no key for version %d", version)
	}
	return enc.Decrypt(encryptedValue[colonIdx+1:])
}

func (ve *VersionedEncryptor) NeedsRotation(encryptedValue string) bool {
	colonIdx := strings.Index(encryptedValue, ":")
	if colonIdx < 2 {
		return true
	}
	version, err := strconv.Atoi(encryptedValue[1:colonIdx])
	if err != nil {
		return true
	}
	return version < ve.currentVersion
}
