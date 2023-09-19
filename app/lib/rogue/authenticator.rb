# frozen_string_literal: true

module Rogue
  # Authenticates request checking for valid JWT
  class Authenticator
    attr_accessor :error, :user

    def initialize(request)
      self.request = request
    end

    def authorized?
      validate_jwt
      user.present?
    end

    private

    attr_accessor :request

    def validate_jwt
      self.user = Rogue::Lockpick.new(token).user
    rescue StandardError => e
      self.error = e
    end

    def token
      raise ::UnauthorizedError, 'No token present' if request.headers['Authorization'].blank?

      header, value = request.headers['Authorization'].split

      raise ::UnauthorizedError, 'Invalid authorization type' unless header == 'Bearer'

      raise ::UnauthorizedError, 'No token present' if value.blank?

      value
    end
  end
end
