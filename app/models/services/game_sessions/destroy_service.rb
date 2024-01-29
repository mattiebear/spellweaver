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
      Game::State::Loader.new(game_session.id).load!.bind do |state|
        state.destroy!.bind do
          author.apply(state)
        end
      end
    end

    def send_destroyed_event
      ActionCable.server.broadcast(story_key, message.to_h)
    end

    def message
      Game::Messaging::Message.new(event: 'complete-story')
    end

    def story_key
      "story:#{game_session.id}"
    end

    def author
      @author ||= Game::Sync::Author.new([:story, game_session.id])
    end
  end
end
