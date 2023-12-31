# frozen_string_literal: true

module Game
  module Messaging
    # Converts a data object into a message
    class MessageLoader
      include Dry::Monads[:result]

      def initialize(source = {})
        @source = source
      end

      def message
        event.bind do |name|
          Success(Message.new(event: name, data:))
        end
      end

      private

      attr_reader :source

      def data
        source[:data] || {}
      end

      def event
        name = source[:event]

        if name.nil?
          Failure(:no_event)
        else
          Success(name.underscore.to_sym)
        end
      end
    end
  end
end
