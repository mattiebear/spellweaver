# frozen_string_literal: true

module Game
  module Messaging
    class Broadcast
      attr_reader :data, :event, :game_session_id, :user

      def initialize(data:, event:, game_session_id:, user:)
        @data = data
        @event = event
        @game_session_id = game_session_id
        @user = user
      end

      def send!
        ActionCable.server.broadcast(story_key, parcel)
      end

      private

      def message
        @message ||= Message.new(event: event.to_s.dasherize, data:)
      end

      def parcel
        DataTransformer.new(message.to_h).outbound
      end

      def story_key
        "story:#{game_session_id}"
      end

      def user_id
        current_user.id
      end

      def user_key
        "#{story_key}:#{user_id}"
      end
    end
  end
end
