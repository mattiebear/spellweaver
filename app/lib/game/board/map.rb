# frozen_string_literal: true

module Game
  module Board
    # The game board providing controls to add, move and remove tokens
    class Map
      include Dry::Monads[:result]

      def initialize(tokens = {})
        @tokens = normalize_as_hash(tokens)
      end

      def add_token(token)
        if token_at?(token.pos)
          Failure(:token_already_at_position)
        else
          tokens[token.id] = token
          Success(token)
        end
      end

      def move_token(id, pos)
        ensure_free(pos).bind do |position|
          get_token(id).bind do |token|
            token.pos = position
            Success(token)
          end
        end
      end

      def remove_token(id)
        get_token(id).bind do |token|
          tokens.delete(id)
          Success(token)
        end
      end

      def get_token(id)
        token = tokens[id]

        if token
          Success(token)
        else
          Failure(:token_not_found)
        end
      end

      def token_at?(pos)
        tokens.any? { |_id, token| token.pos.equals?(pos) }
      end

      def token_count
        tokens.count
      end

      def ensure_free(pos)
        if token_at?(pos)
          Failure(:token_already_at_position)
        else
          Success(pos)
        end
      end

      def to_a
        tokens.map { |_id, token| token.to_h }
      end

      def clear_tokens(&)
        tokens.each_key do |id|
          remove_token(id).bind(&)
        end
      end

      private

      attr_accessor :tokens

      def normalize_as_hash(tokens)
        return tokens if tokens.is_a?(Hash)

        hash = {}

        tokens.each do |token|
          hash[token.id] = token
        end

        hash
      end
    end
  end
end
