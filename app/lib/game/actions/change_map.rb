# frozen_string_literal: true

module Game
  module Actions
    # Change selected map
    class ChangeMap < Action
      def execute!
        load_state.bind do |state|
          state.update(map_id: data[:map_id]).bind do |updated|
						updated.clear_tokens.bind do |cleared|
							author.apply(cleared).bind do |saved|
								success(:change_map, map_id: saved.fields[:map_id])
							end
						end
          end
        end
      end
    end
  end
end
