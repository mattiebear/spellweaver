# frozen_string_literal: true

module Network
  class GetConnections
    include Dry::Monads[:result]

    def initialize(params)
      @user = params[:for]
    end

    def execute
      fetch_connections.bind { |connections| Success(connections) }
    end

    private

    attr_reader :user

    def fetch_connections
      Success(Connection.includes(:users).with_user(user))
    end
  end
end
