# frozen_string_literal: true

module Rogue
  class UserClient
    def initialize
      @client = Clerk::SDK.new
    end

    def find(id)
      data = retrieve_or_fetch_user_by_id(id)
      user(data)
    end

    def search(filters = {})
      fetch_users_by(filters).map { |data| user(data) }
    end

    def search_one(filters = {})
      data = fetch_users_by(filters).first
      user(data)
    end

    # FIXME: Need to find a better way to do this
    def valid_user_ids?(ids)
      ids.all? do |id|
        retrieve_or_fetch_user_by_id(id).present?
      end
    end

    def user(data = {})
      User.new(data)
    end

    private

    attr_reader :client

    def user_key(id)
      "rogue-user-#{id}"
    end

    def retrieve_or_fetch_user_by_id(id)
      Rails.cache.fetch(user_key(id), expires_in: 12.hours) do
        fetch_user_by_id(id)
      end
    end

    def fetch_user_by_id(id)
      client.users.find(id)
    end

    def fetch_users_by(filters)
      client.users.all(filters)
    end
  end
end
