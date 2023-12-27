# frozen_string_literal: true

module GameSessions
  class DestroyService < Service
    def initialize(game_session:)
      super

      self.game_session = game_session
    end

    def tasks
      destroy_story_cache
      send_destroyed_event
    end

    private

    attr_accessor :game_session

    def destroy_story_cache
      book = Story::Book.new(game_session).load!
      book.destroy!
    end

    def send_destroyed_event
      ActionCable.server.broadcast(story_key, message.to_h)
    end

    def message
      Story::Message.new('complete-story')
    end

    def story_key
      "story:#{game_session.id}"
    end
  end
end
