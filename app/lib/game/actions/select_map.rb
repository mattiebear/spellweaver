# frozen_string_literal: true

module Game
  module Actions
    # Distributes message data to the appropriate handler
    class SelectMap < Action
			def execute!
        puts 'Selecting map for game...'
        puts data

        # TODO: Change this, obviously
        Success(ActionResult.new(event: :map_selected, data: data))
			end
    end
  end
end
