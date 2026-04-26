# Feature        : Role-Based Access Control (RBAC) — Rails before_action
# Language       : Ruby 3.3
# Framework      : Rails 7.1
# Level          : Intermediate
# OWASP          : A01 — Broken Access Control
# Protects       : Against unauthorised controller action access by role
# Does NOT cover : Object-level (row-level) authorization — use Pundit for that
# Dependencies   : See Gemfile in this folder
# Tested on      : Ruby 3.3.0, Rails 7.1.3, jwt 2.8.1
# Last reviewed  : 2024-03-01

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# app/models/user.rb
# Add a 'role' string column to your users table:
#   add_column :users, :role, :string, default: 'viewer'
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class User < ApplicationRecord
  ROLE_HIERARCHY = { 'viewer' => 10, 'editor' => 20, 'admin' => 40 }.freeze

  validates :role, inclusion: { in: ROLE_HIERARCHY.keys }

  def has_role?(minimum_role)
    (ROLE_HIERARCHY[role] || 0) >= (ROLE_HIERARCHY[minimum_role.to_s] || 0)
  end

  def admin?  = has_role?('admin')
  def editor? = has_role?('editor')
  def viewer? = has_role?('viewer')
end


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# app/controllers/application_controller.rb
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ApplicationController < ActionController::API
  before_action :authenticate_request!

  private

  def authenticate_request!
    token = request.headers['Authorization']&.remove('Bearer ')
    return render json: { error: 'Authentication required' }, status: :unauthorized unless token

    payload = JWT.decode(token, ENV['SECRET_KEY'], true, algorithms: ['HS256'])[0]
    @current_user = User.find(payload['sub'])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Invalid or expired token' }, status: :unauthorized
  end

  def require_role(minimum_role)
    return if @current_user&.has_role?(minimum_role)
    render json: {
      error: "Access denied. Required: #{minimum_role}. Your role: #{@current_user&.role}"
    }, status: :forbidden
  end

  attr_reader :current_user
end


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# app/controllers/posts_controller.rb
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class PostsController < ApplicationController
  before_action -> { require_role('editor') }, only: [:create, :update]
  before_action -> { require_role('admin') },  only: [:destroy]

  def index
    require_role('viewer')
    render json: { posts: [], user: current_user.id }
  end

  def create
    render json: { created: true }, status: :created
  end

  def destroy
    render json: { deleted: params[:id] }
  end
end


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# config/routes.rb
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Rails.application.routes.draw do
#   resources :posts, only: [:index, :create, :destroy]
#   namespace :admin do
#     resources :users, only: [:index, :destroy]
#   end
# end
