# frozen_string_literal: true

module Game
  module Actions
    # Sends full state of the story
    class SelectMap < Action
      def execute!
        load_state.bind do |state|
          state.update(map_id: data[:map_id]).bind do |updated|
            author.apply(updated).bind do |saved|
              success(:stub_event, saved.fields)
            end
          end
        end
      end
    end
  end
end
