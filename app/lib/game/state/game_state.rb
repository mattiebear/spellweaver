# frozen_string_literal: true

module Game
  module State
    # The entire state of the game
    class GameState
      def initialize(id:, user:, map: Map.new, map_id: nil)
        @id = id
        @user = user

        @map = map
        @map_id = map_id
      end
    end

    private

    attr_accessor :id, :user
  end
end
