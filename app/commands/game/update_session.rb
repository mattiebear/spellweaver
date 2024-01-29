# frozen_string_literal: true

module Game
  class UpdateSession
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def execute(user:, id:, status:)
      session = yield find_session(id)
      yield authorize(session, user)
      yield validate_status(session, status)
      yield destroy_live_session(session)
      session = yield update_session(session, status)

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

    def validate_status(session, status)
      if session.transition_to?(status)
        Success(session)
      else
        failure = CommandFailure.new(:conflict)
                                .add('status', ErrorCode::INVALID, 'Invalid status')

        Failure(failure)
      end
    end

    def destroy_live_session(session)
      if status == 'complete'
        ClearGameboard.new.execute(id: session.id)
      else
        Success()
      end
    end

    def update_session(status)
      if session.update(status:)
        Success(session)
      else
        failure = CommandFailure.new(:unprocessable_entity)

        Failure(failure)
      end
    end
  end
end
