# frozen_string_literal: true

module Rogue
  require 'jwt'

  # Retrieve user information from a JWT token
  class Lockpick
    attr_accessor :error

    def initialize(token)
      self.token = token
    end

    def user_id
      jwt_data[:sub]
    end

    def user
      @user ||= Rogue::UserClient.new.find(user_id)
    end

    private

    attr_accessor :token

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

    def algorithms
      ['RS256']
    end

    def jwks
      JwksClient.new.jwks
    end
  end
end
