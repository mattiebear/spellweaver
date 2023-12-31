# frozen_string_literal: true

module Game
  module Actions
    # Distributes message data to the appropriate handler
    class Director
      include Actionable

      register_action :select_map, SelectMap

      def initialize(message)
        @message = message
      end

      def action
        klass = fetch_action(message.event)

        klass.new(message.data)
      end

      private

      attr_reader :message
    end
  end
end
