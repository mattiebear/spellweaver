# frozen_string_literal: true

module Game
  class DestroySession
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:execute)

    def initialize(by:, session:)
      @session = session
      @user = by
    end

    def execute
      session = yield find_session
      session = yield ensure_user_owns_session
      yield destroy_session
      yield destroy_story_cache
      yield send_destroyed_event
    end

    private

    attr_reader :atlas, :session, :name, :user

    def find_session
      return Success(session) if session.is_a?(Game::Session)

      session = Session.find_by(id: session)

      if session
        Success(session)
      else
        Failure(CommandFailure.new(:not_found))
      end
    end

    def ensure_user_owns_session
      if session.owner?(user)
        Success(session)
      else
        Failure(CommandFailure.new(:unauthorized))
      end
    end

    def destroy_story_cache
      Success(session.story_cache.destroy)

    def destroy_session
      Success(session.destroy)
    end

    def destroy_story_cache
      Game::State::Loader.new(game_session.id).load!.bind do |state|
        state.destroy! do
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
      "story:#{session.id}"
    end

    def author
      @author ||= Game::Sync::Author.new([:story, session.id])
    end
  end
end
