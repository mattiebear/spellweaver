# frozen_string_literal: true

module Game
  module State
    # The entire state of the game
    class GameState
      delegate :add_token, :move_token, :remove_token, to: :map

      def initialize(id:, map:, map_id: nil)
        @id = id
        @map = map
        @map_id = map_id
      end

      def to_h
        {
          map_id:,
          tokens: map.all(&:to_h)
        }
      end
    end

    private

    attr_accessor :id, :map, :map_id
  end
end
