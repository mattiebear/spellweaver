# frozen_string_literal: true

module Game
  class CreateMap
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def initialize(by:, name:, participants:, user_client:)
      @name = name
      @user = by
      @user_ids = participants
      @user_client = user_client
    end

    def execute
      ids = yield validate_user_ids
      ids = yield filter_ids(ids)
      users = yield build_user_data(ids)
      session = yield create_session(name, users)

      Success(session)
    end

    private

    attr_reader :name, :user, :user_ids, :user_client

    def validate_user_ids
      if user_client.valid_user_ids?(user_ids)
        Success(user_ids)
      else
        failure = CommandFailure.new(:unauthorized)
                                .add('user', ErrorCode::NOT_FOUND, 'No user found with provided ID')

        Failure(failure)
      end
    end

    def filter_ids(ids)
      Success(ids - [user.id])
    end

    def build_user_data(ids)
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
