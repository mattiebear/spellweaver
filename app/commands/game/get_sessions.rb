# frozen_string_literal: true

module Game
  class GetSessions
    include Dry::Monads[:result]

    def initialize(**args)
      @user = args[:for]
    end

    def execute
      fetch_sessions(user)
    end

    private

    attr_reader :user

    def fetch_sessions(user)
      Success(Session.includes(:players).with_user(user))
    end
  end
end
