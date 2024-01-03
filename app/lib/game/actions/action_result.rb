# frozen_string_literal: true

module Game
  module Actions
    # Result DTO for actions
    class ActionResult
      attr_accessor :data, :event

      def initialize(event:, data: nil)
        self.data = data
        self.event = event
      end
    end
  end
end
