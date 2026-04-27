# Feature        : Encryption at Rest — AES-256-GCM authenticated encryption
# Language       : Ruby 3.3
# Framework      : None — Ruby standard library OpenSSL
# Level          : Intermediate
# OWASP          : A02 — Cryptographic Failures
# Protects       : Against data exposure from database breaches or stolen backups
# Does NOT cover : Key management infrastructure, transit encryption
# Dependencies   : See Gemfile — OpenSSL is part of Ruby's standard library
# Tested on      : Ruby 3.3.0
# Last reviewed  : 2024-03-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# REPLACE THESE BEFORE USING:
#   ENCRYPTION_KEY — 32 bytes as a 64-char hex string in ENV['ENCRYPTION_KEY']
#                    generate: ruby -e "require 'securerandom'; puts SecureRandom.hex(32)"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

require 'openssl'
require 'securerandom'
require 'base64'

module Encryption
  ALGORITHM  = 'aes-256-gcm'
  KEY_BYTES  = 32
  NONCE_BYTES = 12
  TAG_BYTES  = 16

  # ── Key loading ─────────────────────────────────────────────────────────────

  def self.load_key
    hex_key = ENV.fetch('ENCRYPTION_KEY') do
      raise 'ENCRYPTION_KEY environment variable is not set. ' \
            'Generate one with: ruby -e "require \'securerandom\'; puts SecureRandom.hex(32)"'
    end

    key = [hex_key].pack('H*')
    raise "ENCRYPTION_KEY must be #{KEY_BYTES} bytes (#{KEY_BYTES * 2} hex chars). Got #{key.bytesize}." \
      unless key.bytesize == KEY_BYTES

    key
  end

  ENCRYPTION_KEY = load_key

  # ── Core encrypt / decrypt ───────────────────────────────────────────────────

  # Encrypts a string using AES-256-GCM.
  # Returns a base64url string: "<nonce>.<ciphertext>.<tag>"
  # A unique nonce is generated for every call — never reuse with the same key.
  def self.encrypt(plaintext)
    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.encrypt
    cipher.key = ENCRYPTION_KEY

    nonce = cipher.random_iv  # random 12-byte nonce
    cipher.auth_data = ''     # additional authenticated data (empty here)

    ciphertext = cipher.update(plaintext.encode('UTF-8')) + cipher.final
    tag        = cipher.auth_tag(TAG_BYTES)

    [
      Base64.urlsafe_encode64(nonce,      padding: false),
      Base64.urlsafe_encode64(ciphertext, padding: false),
      Base64.urlsafe_encode64(tag,        padding: false),
    ].join('.')
  end

  # Decrypts a value produced by encrypt.
  # Verifies the GCM authentication tag — raises OpenSSL::Cipher::CipherError if tampered.
  def self.decrypt(encrypted_value)
    parts = encrypted_value.split('.')
    raise ArgumentError, "Invalid format: expected '<nonce>.<ciphertext>.<tag>'" unless parts.length == 3

    nonce      = Base64.urlsafe_decode64(parts[0])
    ciphertext = Base64.urlsafe_decode64(parts[1])
    tag        = Base64.urlsafe_decode64(parts[2])

    cipher = OpenSSL::Cipher.new(ALGORITHM)
    cipher.decrypt
    cipher.key      = ENCRYPTION_KEY
    cipher.iv       = nonce
    cipher.auth_tag = tag
    cipher.auth_data = ''

    # update + final verifies the tag — raises CipherError if tampered
    (cipher.update(ciphertext) + cipher.final).force_encoding('UTF-8')
  rescue OpenSSL::Cipher::CipherError
    raise 'Decryption failed. Data may have been tampered with or key is incorrect.'
  end

  # ── Rails ActiveRecord model integration ─────────────────────────────────────

  # Include in any ActiveRecord model to encrypt specific fields transparently.
  # Requires: gem 'attr_encrypted' in Gemfile
  #
  # Usage:
  #   class User < ApplicationRecord
  #     include Encryption::EncryptedAttributes
  #     encrypt_attribute :national_id, :passport_number
  #   end
  #
  #   user = User.new(national_id: '123456789')
  #   user.save!
  #   # => DB stores encrypted value, user.national_id returns '123456789'
  module EncryptedAttributes
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def encrypt_attribute(*attrs)
        attrs.each do |attr|
          encrypted_attr = :"encrypted_#{attr}"

          define_method(attr) do
            raw = send(encrypted_attr)
            return nil if raw.nil?
            Encryption.decrypt(raw)
          end

          define_method(:"#{attr}=") do |value|
            send(:"#{encrypted_attr}=", value.nil? ? nil : Encryption.encrypt(value.to_s))
          end
        end
      end
    end
  end
end
