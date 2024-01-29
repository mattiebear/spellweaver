# frozen_string_literal: true

module Game
  class CreateSession
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def execute(user:, name:, participants:)
      ids = yield validate_user_ids(participants)
      ids = yield filter_ids(ids, user)
      users = yield build_user_data(ids, user)
      session = yield create_session(name, users)

      Success(session)
    end

    private

    def validate_user_ids(user_ids)
      client = Rogue::UserClient.new

      if client.valid_user_ids?(user_ids)
        Success(user_ids)
      else
        failure = CommandFailure.new(:unauthorized)
                                .add('user', ErrorCode::NOT_FOUND, 'No user found with provided ID')

        Failure(failure)
      end
    end

    def filter_ids(ids, user)
      Success(ids - [user.id])
    end

    def build_user_data(ids, user)
      data = ids.map do |user_id|
        { user_id:, role: 'participant' }
      end

      data << { user_id: user.id, role: 'owner' }

      Success(data)
    end

    def create_session(name, users)
      Game::Session.transaction do
        game_session = Game::Session.create(name:, status: 'pending')

        game_session.players.create(users)
        game_session.players.reload

        Success(game_session)
      end
    end
  end
end
