# frozen_string_literal: true

module Rogue
  class UserClient
    def initialize
      self.client = Clerk::SDK.new
    end

    def find_one(data = {})
      user_data = find_one_raw(data)

      User.new(user_data) if user_data
    end

    def find_one_raw(data = {})
      Rails.cache.fetch(user_key(data), expires_in: 12.hours) do
        fetch_user(data)
      end
    end

    private

    attr_accessor :client

    def user_key(data = {})
      "rogue-user-#{data}"
    end

    def fetch_user(data)
      client.users.all(data).first
    end
  end
end
