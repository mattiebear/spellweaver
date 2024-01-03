# frozen_string_literal: true

module Game
  module Actions
    # Move a token to the specified position
    class MoveToken < Action
      def execute!
        load_state.bind do |state|
          state.move_token(token_id, pos).bind do |t|
            author.apply(state).bind do
              success(:move_token, response_data(t))
            end
          end
        end
      end

      private

      def pos
        Board::Position.new.load(data[:pos])
      end

      def token_id
        data[:token_id]
      end

      def response_data(token)
        { token_id: token.id, pos: token.pos.to_a }
      end
    end
  end
end
