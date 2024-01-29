# frozen_string_literal: true

# Main controller for application
class ApplicationController < ActionController::API
  include Rogue::JwtAuthenticable
  include Transmittable

  before_action :authenticate_user

  rescue_from StandardError, with: :respond_with_unknown_error

  def respond_with_unknown_error(err)
    # TODO: Remove error and use logging instead
    puts 'ERROR'
    puts err.backtrace
    render json: { message: err.message }, status: :internal_server_error
  end
end
