# frozen_string_literal: true

# Main controller for application
class ApplicationController < ActionController::API
  include Rogue::JwtAuthenticable
  include Pundit::Authorization

  before_action :authenticate_user

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  rescue_from StandardError, with: :respond_with_unknown_error
  rescue_from ActiveRecord::RecordNotFound, with: :respond_with_not_found
  rescue_from HttpError, with: :respond_with_http_error

  def respond_with_unknown_error(err)
    # TODO: Remove error and use logging instead
    render json: { message: err.message }, status: :internal_server_error
  end

  def respond_with_not_found
    render nothing: true, status: :not_found
  end

  def respond_with_http_error(err)
    if err.expose
      render json: err.to_json, status: err.status
    else
      render nothing: true, status: err.status
    end
  end
end
