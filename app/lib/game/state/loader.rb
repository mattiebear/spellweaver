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
        Success(GameState.new(id:, fields:, map:))
      end

      private

      attr_accessor :id

      def author
        @author ||= Sync::Author.new([:story, id])
      end

      def fields
        author.load(:fields).symbolize_keys
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
