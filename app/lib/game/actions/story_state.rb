# frozen_string_literal: true

module Game
  module Actions
    # Sends full state of the story
    class StoryState < Action
			def execute!
        puts 'Sending initial state'
        puts data

        Success(ActionResult.new(event: :test_event, data: { success: true }))
			end

      private

      def id
        
      end
    end
  end
end
