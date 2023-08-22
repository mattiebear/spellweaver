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

    attr_accessor :game_session, :name, :user, :user_ids, :user_client

    def validate_user_ids
      debugger

      return if user_client.valid_user_ids?(user_ids)

      raise NotFoundError.new.add('user', ErrorCode::NOT_FOUND,
                                  'No user found with provided ID')
    end

    def create_game_session
      GameSession.transaction do
        self.game_session = GameSession.create(status: 'pending')

        game_session.players.create(users)
        game_session.players.reload
        game_session.players.each(&:load_user!)

        self.result = game_session
      end
    end

    def users
      data = user_ids.map do |user_id|
        { user_id:, role: 'participant' }
      end

      data << { user_id: user.id, role: 'owner' }
    end
  end
end
