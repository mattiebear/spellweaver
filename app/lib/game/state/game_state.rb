# frozen_string_literal: true

module Game
  module State
    # The entire state of the game
    class GameState
      include Dry::Monads[:result]

      # List of single value fields to track for each map
      TRACKED_FIELDS = %i[map_id].freeze

      attr_accessor :changes, :fields, :id, :map

      def initialize(id:, map: Board::Map.new, fields: {})
        @id = id
        @fields = fields
        @map = map

        @changes = []
      end

      def destroy!
        clear_tokens.bind do
          add_changeset(:delete, :fields)
        end
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
          commit_token(t)
          Success(t)
        end
      end

      def remove_token(id)
        map.remove_token(id).bind do |t|
          add_changeset(:delete, token_key(t))
          Success(t)
        end
      end

      def move_token(id, pos)
        map.move_token(id, pos).bind do |t|
          commit_token(t)
          Success(t)
        end
      end

      def clear_tokens
        map.clear_tokens do |token|
          add_changeset(:delete, token_key(token))
        end

        Success(self)
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

      def token_key(token)
        [:token, token.id]
      end

      def token_data(token)
        Board::TokenSerializer.new(token).data
      end

      def commit_token(token)
        add_changeset(:set, token_key(token), token_data(token))
      end
    end
  end
end
