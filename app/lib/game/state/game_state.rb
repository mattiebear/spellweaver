# frozen_string_literal: true

module Game
  module State
    # The entire state of the game
    class GameState
      include Dry::Monads[:result]

      # List of single value fields to track for each map
      TRACKED_FIELDS = %i[map_id].freeze

      attr_accessor :changes, :fields, :id, :map

      def initialize(id:, map:, fields: {})
        @id = id
        @fields = fields
        @map = map

        @changes = []
      end

      def update(data)
        data.each do |key, value|
          return Failure("Invalid key: #{key}") unless TRACKED_FIELDS.include?(key)

          fields[key] = value
        end

        add_changeset(:set, :fields, fields)

        Success(self)
      end

      def add_token(token)
        map.add_token(token).bind do |t|
          add_changeset(:set, [:token, t.id], Board::TokenSerializer.new(token).data)
          Success(t)
        end
      end

      def remove_token(id)
        map.remove_token(id).bind do |t|
          add_changeset(:delete, [:token, t.id])
          Success(t)
        end
      end

      def to_h
        data = { tokens: map.to_a }

        TRACKED_FIELDS.each do |attr|
          data[attr] = fields[attr]
        end

        data
      end

      private

      def add_changeset(type, key, value = nil)
        changes << Sync::Changeset.new(key:, type:, value:)
      end
    end
  end
end
