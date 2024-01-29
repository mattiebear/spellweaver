# frozen_string_literal: true

module Network
  class GetConnections
    include Dry::Monads[:result]

    def self.execute(user:)
      fetch_connections(user).bind { |connections| Success(connections) }
    end

    private

    def fetch_connections(user)
      Success(Connection.includes(:users).with_user(user))
    end
  end
end
