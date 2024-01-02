# frozen_string_literal: true

module Game
  module State
    # The entire state of the game
    class GameState
      delegate :add_token, :move_token, :remove_token, to: :map

      attr_accessor :changes

      def initialize(id:, map:, map_id: nil)
        @id = id
        @map = map
        @map_id = map_id

        @changes = []
      end

      def mutate(data)
        data.each_key do |key|
          return Failure("Invalid key: #{key}") unless defined?("#{key}=")
        end

        data.each do |key, value|
          send("#{key}=", value)
          add_changeset(:set, key, value)
        end

        Success(self)
      end

      def to_h
        {
          map_id:,
          tokens: map.to_a
        }
      end

      private

      attr_accessor :id, :map, :map_id

      def add_changeset(type, key, value)
        changes << Changeset.new(key:, type:, value:)
      end
    end
  end
end
