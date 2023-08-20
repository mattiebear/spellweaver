# frozen_string_literal: true

module Rogue
  require 'uri'
  require 'net/http'

  # Fetches and stores JWKS response from authorization server
  class JwksClient
    CACHE_KEY = 'rogue-jwksclient-keys'

    def jwks
      Rails.cache.fetch(JwksClient::CACHE_KEY, expires_in: 12.hours) do
        fetch_jwks
      end
    end

    private

    def jwks_uri
      ENV.fetch('JWKS_URI', nil)
    end

    def fetch_jwks
      uri = URI(jwks_uri)
      res = Net::HTTP.get_response(uri)

      return JSON.parse(res.body).deep_symbolize_keys if res.is_a?(Net::HTTPSuccess)

      raise StandardError, 'Unable to fetch JWKS'
    end
  end
end
