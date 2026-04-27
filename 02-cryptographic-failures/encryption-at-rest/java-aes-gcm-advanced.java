// Feature        : Encryption at Rest — AES-256-GCM authenticated encryption
// Language       : Java 21
// Framework      : None — Java standard library javax.crypto
// Level          : Advanced
// OWASP          : A02 — Cryptographic Failures
// Protects       : Against data exposure from database breaches or stolen backups
// Does NOT cover : Key management infrastructure, HSM integration, transit encryption
// Dependencies   : None — Java standard library only (javax.crypto, java.security)
// Tested on      : Java 21, OpenJDK
// Last reviewed  : 2024-03-01

package com.websecuritysnippets.encryption;

import javax.crypto.*;
import javax.crypto.spec.*;
import java.security.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * AES-256-GCM encryption utility for sensitive data at rest.
 *
 * Encrypted format stored in database:
 *   <base64url_nonce>.<base64url_ciphertext_with_tag>
 *
 * With versioning:
 *   v{version}:<base64url_nonce>.<base64url_ciphertext_with_tag>
 */
public class AesGcmEncryptor {

    private static final String ALGORITHM   = "AES/GCM/NoPadding";
    private static final int    KEY_BITS    = 256;
    private static final int    NONCE_BYTES = 12;  // 96-bit nonce — GCM standard
    private static final int    TAG_BITS    = 128; // 16-byte authentication tag

    private final byte[] key;

    /**
     * @param key 32-byte AES-256 key. Load from environment or secrets manager.
     * @throws IllegalArgumentException if the key is not exactly 32 bytes.
     */
    public AesGcmEncryptor(byte[] key) {
        if (key == null || key.length != KEY_BITS / 8) {
            throw new IllegalArgumentException(
                "Key must be " + (KEY_BITS / 8) + " bytes for AES-256. Got: " +
                (key == null ? "null" : key.length)
            );
        }
        this.key = Arrays.copyOf(key, key.length);
    }

    /**
     * Load key from environment variable ENCRYPTION_KEY (hex-encoded).
     * Throws if the variable is missing or the key is the wrong length.
     */
    public static AesGcmEncryptor fromEnvironment() {
        String hexKey = System.getenv("ENCRYPTION_KEY");
        if (hexKey == null || hexKey.isEmpty()) {
            throw new IllegalStateException(
                "ENCRYPTION_KEY environment variable is not set"
            );
        }
        byte[] key = HexFormat.of().parseHex(hexKey);
        return new AesGcmEncryptor(key);
    }

    /**
     * Encrypt a string using AES-256-GCM.
     *
     * @param  plaintext The sensitive value to encrypt.
     * @return           Base64url-encoded "<nonce>.<ciphertext_with_tag>"
     */
    public String encrypt(String plaintext) {
        try {
            // Generate a unique nonce for every encryption — NEVER reuse with same key
            byte[] nonce = new byte[NONCE_BYTES];
            SecureRandom.getInstanceStrong().nextBytes(nonce);

            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(
                Cipher.ENCRYPT_MODE,
                new SecretKeySpec(key, "AES"),
                new GCMParameterSpec(TAG_BITS, nonce)
            );

            // The GCM tag is appended automatically by Java's cipher implementation
            byte[] ciphertext = cipher.doFinal(plaintext.getBytes(java.nio.charset.StandardCharsets.UTF_8));

            Base64.Encoder enc = Base64.getUrlEncoder().withoutPadding();
            return enc.encodeToString(nonce) + "." + enc.encodeToString(ciphertext);

        } catch (GeneralSecurityException e) {
            throw new EncryptionException("Encryption failed", e);
        }
    }

    /**
     * Decrypt a value produced by encrypt().
     * Verifies the GCM tag — throws if data was tampered with or the key is wrong.
     *
     * @param  encryptedValue The value returned by encrypt().
     * @return                The original plaintext.
     * @throws EncryptionException if decryption or tag verification fails.
     */
    public String decrypt(String encryptedValue) {
        String[] parts = encryptedValue.split("\\.", 2);
        if (parts.length != 2) {
            throw new EncryptionException("Invalid encrypted value format", null);
        }

        try {
            Base64.Decoder dec = Base64.getUrlDecoder();
            byte[] nonce      = dec.decode(parts[0]);
            byte[] ciphertext = dec.decode(parts[1]);

            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(
                Cipher.DECRYPT_MODE,
                new SecretKeySpec(key, "AES"),
                new GCMParameterSpec(TAG_BITS, nonce)
            );

            // doFinal verifies the GCM tag — throws AEADBadTagException if tampered
            byte[] plaintext = cipher.doFinal(ciphertext);
            return new String(plaintext, java.nio.charset.StandardCharsets.UTF_8);

        } catch (AEADBadTagException e) {
            throw new EncryptionException(
                "Decryption failed: ciphertext may be tampered with or key is incorrect", e
            );
        } catch (GeneralSecurityException e) {
            throw new EncryptionException("Decryption failed", e);
        }
    }

    // ── Versioned key rotation ────────────────────────────────────────────────

    /**
     * VersionedEncryptor supports key rotation.
     * Stored format: v{version}:{nonce_b64url}.{ciphertext_b64url}
     */
    public static class VersionedEncryptor {
        private final Map<Integer, AesGcmEncryptor> encryptors = new ConcurrentHashMap<>();
        private final int currentVersion;

        /**
         * @param keys Map of version int → 32-byte key bytes.
         *             Highest version number is used for new encryptions.
         */
        public VersionedEncryptor(Map<Integer, byte[]> keys) {
            if (keys.isEmpty()) throw new IllegalArgumentException("At least one key version required");
            keys.forEach((v, k) -> encryptors.put(v, new AesGcmEncryptor(k)));
            this.currentVersion = keys.keySet().stream().mapToInt(Integer::intValue).max().orElseThrow();
        }

        public String encrypt(String plaintext) {
            return "v" + currentVersion + ":" + encryptors.get(currentVersion).encrypt(plaintext);
        }

        public String decrypt(String encryptedValue) {
            if (!encryptedValue.startsWith("v")) throw new EncryptionException("Missing version prefix", null);
            int colonIdx = encryptedValue.indexOf(':');
            int version  = Integer.parseInt(encryptedValue.substring(1, colonIdx));
            AesGcmEncryptor enc = encryptors.get(version);
            if (enc == null) throw new EncryptionException("No key for version " + version, null);
            return enc.decrypt(encryptedValue.substring(colonIdx + 1));
        }

        public boolean needsRotation(String encryptedValue) {
            int colonIdx = encryptedValue.indexOf(':');
            if (colonIdx < 2) return true;
            return Integer.parseInt(encryptedValue.substring(1, colonIdx)) < currentVersion;
        }
    }

    // ── Exception ─────────────────────────────────────────────────────────────

    public static class EncryptionException extends RuntimeException {
        public EncryptionException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
