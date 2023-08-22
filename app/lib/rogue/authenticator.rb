# frozen_string_literal: true

module Rogue
  require 'jwt'

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
      self.user = Rogue::UserClient.new.find(user_id)
    rescue StandardError => e
      self.error = e
    end

    def jwt_data
      JWT.decode(token, nil, true, algorithms:, jwks:).first.symbolize_keys
    rescue JWT::JWKError
      raise ::UnauthorizedError, 'Invalid JWKS'
    rescue JWT::DecodeError
      raise ::UnauthorizedError, 'Invalid token'
    end

    def user_id
      jwt_data[:sub]
    end

    def algorithms
      ['RS256']
    end

    def jwks
      JwksClient.new.jwks
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
