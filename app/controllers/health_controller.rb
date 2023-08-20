# frozen_string_literal: true

# Controller for basic server health checks
class HealthController < ApplicationController
  def index
    render json: { status: 'pong' }
  end
end
