# frozen_string_literal: true

module Game
  module Actions
    # Adds a token to the board
    class AddToken < Action
      def execute!
        load_state.bind do |state|
          state.add_token(token).bind do |t|
            author.apply(state).bind do
              success(:add_token, t.to_h)
            end
          end
        end
      end

      private

      def pos
        Board::Position.new.load(data[:pos])
      end

      def token
        Board::Token.new(
          user_id: user.id,
          token_id: data[:token_id],
          pos:
        ).generate_id!
      end
    end
  end
end
