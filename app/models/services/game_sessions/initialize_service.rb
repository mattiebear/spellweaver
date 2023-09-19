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
      Story::Book.new(game_session).save!
    end
  end
end
