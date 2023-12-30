# frozen_string_literal: true

module Game
  module Messaging
    # A message struct for sending data between the game and the client
    class Message
      attr_reader :event, :data

      def initialize(event:, data: nil)
        @event = event
        @data = data
      end

      def to_h
        { event:, data: }
      end
    end
  end
end
