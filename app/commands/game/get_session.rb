# frozen_string_literal: true

module Game
  class GetSession
    include Dry::Monads[:result]

    def execute(user:, id:)
      find_session(id).bind { |session| authorize(session, user) }
    end

    private

    def find_session(id)
      session = Session.find_by(id:)

      if session
        Success(session)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def authorize(session, user)
      if session.includes_user?(user)
        Success(session)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end
  end
end
