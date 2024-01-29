# frozen_string_literal: true

module Game
  class GetSessions
    include Dry::Monads[:result]

    def execute(user:)
      fetch_sessions(user)
    end

    private

    def fetch_sessions(user)
      Success(Session.includes(:players).with_user(user))
    end
  end
end
