# frozen_string_literal: true

module Story
  class Book
    def initialize(map_id: nil, players: [], state: [])
      self.map_id = map_id
      self.players = players
      self.state = state
    end

    def to_h
      {
        map_id:,
        players:,
        state:
      }
    end

    def to_json(...)
      to_h.to_json(...)
    end

    class << self
      def load(data = {})
        new(map_id: data[:map_id], players: data[:players], state: data[:state])
      end

      def from_session(game_session)
        players = game_session.players.map { |player| story_player(player) }

        new(players:)
      end

      private

      def story_player(player)
        {
          image: nil,
          role: player.role,
          user_id: player.user_id
        }
      end
    end

    private

    attr_accessor :map_id, :players, :state
  end
end
