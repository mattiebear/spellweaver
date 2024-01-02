# frozen_string_literal: true

module Game
  module Board
    class TokenLoader
      def initialize(**data)
        @data = data.with_indifferent_access
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
        @data[:x]
      end

      def y
        @data[:y]
      end

      def z
        @data[:z]
      end
    end
  end
end
