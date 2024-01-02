# frozen_string_literal: true

module Game
  module Actions
    # Distributes message data to the appropriate handler
    class Director
      include Actionable
      include Dry::Monads[:maybe]

      register_action :select_map, SelectMap

      def initialize(game_session_id:, message:, user:)
        @game_session_id = game_session_id
        @message = message
        @user = user
      end

      def action
        klass = fetch_action(message.event)

        if klass.nil?
          None()
        else
          Some(klass.new(data: message.data, game_session_id:, user:))
        end
      end

      private

      attr_reader :game_session_id, :message, :user
    end
  end
end
