# frozen_string_literal: true

module GameSessions
  class CreateService < Service
    def initialize(user:, name:, user_ids:)
      super

      self.user = user
      self.name = name
      self.user_ids = user_ids
      self.user_client = Rogue::UserClient.new
    end

    def tasks
      validate_user_ids
      create_game_session
    end

    private

    attr_accessor :name, :user, :user_ids, :user_client

    def validate_user_ids
      return if user_client.valid_user_ids?(user_ids)

      raise NotFoundError.new.add('user', ErrorCode::NOT_FOUND,
                                  'No user found with provided ID')
    end

    def create_game_session
      GameSession.transaction do
        game_session = GameSession.create(name:, status: 'pending')

        game_session.players.create(users)
        game_session.players.reload

        self.result = game_session
      end
    end

    def users
      data = filtered_ids.map do |user_id|
        { user_id:, role: 'participant' }
      end

      data << { user_id: user.id, role: 'owner' }
    end

    def filtered_ids
      user_ids - [user.id]
    end
  end
end
