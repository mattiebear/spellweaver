# frozen_string_literal: true

module Game
  module Actions
    # Sends full state of the story
    class SelectMap < Action
      def execute!
        load_state.bind do |state|
          state.mutate(map_id: data[:map_id]).bind do |updated|
            author.apply(updated).bind do |saved|
              # TODO: Refactor this to follow request pattern
              success(:stub_event, { map_id: saved.map_id })
            end
          end
        end
      end
    end
  end
end
