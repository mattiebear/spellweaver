# frozen_string_literal: true

module Game
  module Board
    class TokenLoader
      def initialize(data)
        @data = data.symbolize_keys
      end

      def token
        @token ||= Token.new(id:, user_id:, token_id:, pos:)
      end

      def pos
        @pos ||= Position.new(x:, y:, z:)
      end

      private

      def id
        @data[:id]
      end

      def user_id
        @data[:user_id]
      end

      def token_id
        @data[:token_id]
      end

      def x
        @data[:x].to_i
      end

      def y
        @data[:y].to_i
      end

      def z
        @data[:z].to_i
      end
    end
  end
end
