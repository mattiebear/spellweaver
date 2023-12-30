# frozen_string_literal: true

module Game
  module Messaging
		# Converts a data object into a message
    class MessageLoader
      def initialize(source = {})
        @source = source
      end

      def message
        @message ||= compose_message(source)
      end

      private

			attr_reader :source

      def compose_message(source)
				data = source[:data] || {}
				event = source[:event] || :unknown_event

        Message.new(event:, data:)
      end
    end
  end
end
