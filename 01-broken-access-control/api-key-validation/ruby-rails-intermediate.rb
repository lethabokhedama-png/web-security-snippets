# Feature        : API Key Validation — Rails before_action with HMAC hashing
# Language       : Ruby 3.3
# Framework      : Rails 7.1
# Level          : Intermediate
# OWASP          : A01 — Broken Access Control
# Protects       : Against unauthorised API access and plain-text key storage
# Does NOT cover : Key rotation UI, granular per-route scope enforcement beyond listed
# Dependencies   : See Gemfile in this folder
# Tested on      : Ruby 3.3.0, Rails 7.1.3
# Last reviewed  : 2024-03-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# app/models/api_key.rb
# Migration: add_column :api_keys, :key_hash, :string, null: false, index: true
#            add_column :api_keys, :client_id, :integer, null: false
#            add_column :api_keys, :scopes, :text, array: true, default: []
#            add_column :api_keys, :active, :boolean, default: true
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

require 'openssl'
require 'securerandom'

class ApiKey < ApplicationRecord
  HMAC_SECRET = ENV.fetch('HMAC_SECRET') { raise 'HMAC_SECRET env var is required' }

  belongs_to :client

  def self.generate_for(client, scopes: ['read:data'])
    raw_key  = SecureRandom.urlsafe_base64(32)
    key_hash = hmac_hash(raw_key)
    record   = create!(client: client, key_hash: key_hash, scopes: scopes, active: true)
    [raw_key, record]  # raw_key shown once — never stored
  end

  def self.authenticate(raw_key)
    incoming_hash = hmac_hash(raw_key)
    # Constant-time comparison via OpenSSL — prevents timing attacks
    find_each do |key|
      if OpenSSL.fixed_length_secure_compare(key.key_hash, incoming_hash) && key.active?
        return key
      end
    end
    nil
  end

  def has_scope?(required_scope)
    scopes.include?(required_scope.to_s)
  end

  private

  def self.hmac_hash(raw_key)
    OpenSSL::HMAC.hexdigest('SHA256', HMAC_SECRET, raw_key)
  end
end


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# app/controllers/application_controller.rb
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ApplicationController < ActionController::API
  private

  def authenticate_api_key!(required_scope: nil)
    raw_key = request.headers['X-API-Key']
    return render json: { error: 'API key required' }, status: :unauthorized unless raw_key

    @current_api_key = ApiKey.authenticate(raw_key)
    return render json: { error: 'Invalid or revoked API key' }, status: :unauthorized unless @current_api_key

    if required_scope && !@current_api_key.has_scope?(required_scope)
      render json: { error: 'Insufficient scope', required: required_scope }, status: :forbidden
    end
  end

  attr_reader :current_api_key
end


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# app/controllers/api/data_controller.rb
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

module Api
  class DataController < ApplicationController
    before_action -> { authenticate_api_key!(required_scope: 'read:data') },  only: [:index]
    before_action -> { authenticate_api_key!(required_scope: 'write:data') }, only: [:create]

    def index
      render json: { data: [], client: current_api_key.client_id }
    end

    def create
      render json: { created: true }, status: :created
    end
  end
end
