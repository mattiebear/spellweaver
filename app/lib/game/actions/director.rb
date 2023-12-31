# frozen_string_literal: true

module Game
  module Actions
    # Distributes message data to the appropriate handler
    class Director
      include Actionable
      include Dry::Monads[:maybe]

      register_action :select_map, SelectMap

      def initialize(message)
        @message = message
      end

      def action
        klass = fetch_action(message.event)

        if klass.nil?
          None()
        else
          Some(klass.new(message.data))
        end
      end

      private

      attr_reader :message
    end
  end
end
