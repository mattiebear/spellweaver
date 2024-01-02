# frozen_string_literal: true

module Game
  module Actions
    # Sends full state of the story
    class StoryState < Action
      def execute!
        load_state.bind do |state|
          success(:current_story_state, state.to_h)
        end
      end
    end
  end
end
