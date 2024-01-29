# frozen_string_literal: true

module Game
  class DestroyMap
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def execute(user:, id:)
      session = yield find_session(id)
      yield authorize(session, user)
      yield destroy_live_session(session)
      yield destroy_session(session)

      Success(session)
    end

    private

    def find_session(id)
      session = Game::Session.find_by(id:)

      if session
        Success(session)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def authorize(session, user)
      if session.owner?(user)
        Success(session)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end

    def destroy_live_session(session)
      ClearGameboard.new.execute(id: session.id)
    end

    def destroy_session(session)
      Success(session.destroy)
    end
  end
end
