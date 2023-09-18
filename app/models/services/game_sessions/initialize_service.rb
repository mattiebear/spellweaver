# frozen_string_literal: true

module GameSessions
  class InitializeService < Service
    def initialize(game_session:)
      super

      self.game_session = game_session
    end

    def tasks
      initialize_story_cache
    end

    private

    attr_accessor :game_session

    def initialize_story_cache
      data = Story::Book.from_session(game_session).to_h

      story_client.set(story_key, data.to_json)
    end

    def story_key
      "story_#{game_session.id}"
    end

    def story_client
      Persist::Client.instance
    end
  end
end
