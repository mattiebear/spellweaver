# frozen_string_literal: true

module Game
  module Actions
    # Sends full state of the story
    class StoryState < Action
      def execute!
        State::Sync.new(game_session_id).load!.bind do |state|
          Success(ActionResult.new(event: :current_story_state, data: state.to_h))
        end
      end
    end
  end
end
