# frozen_string_literal: true

module Game
  module Actions
    # Removes token from the board
    class RemoveToken < Action
      def execute!
        load_state.bind do |state|
          state.remove_token(token_id).bind do |t|
            author.apply(state).bind do
              success(:remove_token, token_id: t.id)
            end
          end
        end
      end

      private

      def token_id
        data[:token_id]
      end
    end
  end
end
