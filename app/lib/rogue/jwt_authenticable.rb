# frozen_string_literal: true

module Rogue
  # Provides utilities for authenticating users with a JWT
  module JwtAuthenticable
    extend ActiveSupport::Concern

    included do
      attr_reader :current_user

      def authenticate_user
        authenticator = Authenticator.new(request)

        raise authenticator.error unless authenticator.authorized?

        @current_user = authenticator.user
      end
    end
  end
end
