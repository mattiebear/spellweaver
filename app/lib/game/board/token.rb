# frozen_string_literal: true

require 'securerandom'

module Game
  module Board
    # Represents a single dynamic token on the game board
    class Token
      attr_accessor :id, :pos, :token_id, :user_id

      def initialize(id: nil, user_id: nil, token_id: nil, pos: nil)
        @id = id
        @pos = pos
        @token_id = token_id
        @user_id = user_id
      end

      def valid?
        %i[id pos token_id user_id].all? { |attr| send(attr) }
      end
    end
  end
end
