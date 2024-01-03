# frozen_string_literal: true

module Game
  module Board
    class TokenSerializer
			attr_reader :token

      def initialize(token)
        @token = token
      end

			def data
				@data ||= {
					id: token.id,
					user_id: token.user_id,
					token_id: token.token_id,
					x: token.pos.x,
					y: token.pos.y,
					z: token.pos.z
				}
			end
    end
  end
end
