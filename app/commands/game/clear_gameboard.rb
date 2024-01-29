# frozen_string_literal: true

module Game
  class ClearGameboard
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def execute(id:)
      yield destroy_story_cache(id)
      yield send_destroyed_event(id)
    end

    private

    def destroy_story_cache(id)
      author = Game::Sync::Author.new([:story, id])

      Game::State::Loader.new(id).load!.bind do |state|
        state.destroy! do
          author.apply(state)
        end
      end
    end

    def send_destroyed_event(id)
      story_key = "story:#{id}"

      ActionCable.server.broadcast(story_key, message.to_h)
    end

    def message
      Game::Messaging::Message.new(event: 'complete-story')
    end
  end
end
