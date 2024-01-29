# frozen_string_literal: true

module Game
  class UpdateMap
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def initialize(by:, id:, status:)
      @id = id
      @status = status
      @user = by
    end

    def execute
      @session = yield find_session
      session = yield ensure_user_owns_session(session)
      yield validate_status
      yield destroy_live_session

      Success(session)
    end

    private

    attr_reader :id, :session, :status, :user

    def find_session
      session = Game::Session.find_by(id:)

      if session
        Success(session)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def ensure_user_owns_session(session)
      if session.owner?(user)
        Success(session)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end

    def validate_status
      if completed? || restricted?
        failure = CommandFailure.new(:conflict)
                                .add('status', ErrorCode::INVALID, 'Invalid status')
        Failure(failure)
      else
        Success()
      end
    end

    def destroy_live_session
      if destroy?
        Game::DestroySession.new(by: user, session:).execute
      else
        Success()
      end
    end

    def update_session
      if session.update(status:)
        Success(session)
      else
        failure = CommandFailure.new(:unprocessable_entity)
                                
        Failure(failure)
      end
    end

    def completed?
      session.complete?
    end

    def restricted?
      session.active? && status != 'complete'
    end

    def destroy?
      status == 'complete'
    end


    # def validate_user_ids(user_ids)
    #   if user_client.valid_user_ids?(user_ids)
    #     Success(user_ids)
    #   else
    #     failure = CommandFailure.new(:unauthorized)
    #                             .add('user', ErrorCode::NOT_FOUND, 'No user found with provided ID')

    #     Failure(failure)
    #   end
    # end

    # def filter_ids(ids, user)
    #   Success(ids - [user.id])
    # end

    # def build_user_data(ids, user)
    #   data = ids.map do |user_id|
    #     { user_id:, role: 'participant' }
    #   end

    #   data << { user_id: user.id, role: 'owner' }

    #   Success(data)
    # end

    # def create_session(name, users)
    #   Game::Session.transaction do
    #     game_session = Game::Session.create(name:, status: 'pending')

    #     game_session.players.create(users)
    #     game_session.players.reload

    #     Success(game_session)
    #   end
    # end
  end
end
