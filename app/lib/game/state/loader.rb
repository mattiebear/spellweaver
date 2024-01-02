# frozen_string_literal: true

module Game
  module State
    # Loads the persisted state of the game
    class Loader
      include Dry::Monads[:result]

      def initialize(id)
        @id = id
      end

      def load!
        Success(GameState.new(id:, map:, map_id:))
      end

      private

      attr_accessor :id

      def author
        @author ||= Sync::Author.new([:story, id])
      end

      def load_field(field)
        author.load(field)
      end

      def map_id
        @map_id ||= load_field(:map_id)
      end

      def map
        @map ||= Board::Map.new(tokens)
      end

      def tokens
        author.load_each(:token) do |data|
          Board::TokenLoader.new(data).token
        end
      end
    end
  end
end
