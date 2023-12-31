# frozen_string_literal: true

module Game
  module Actions
    # Base class for all executable actions
    class Action
      include Dry::Monads[:result]

      def initialize(data = nil)
        self.data = data
      end

      def execute!
        raise NoMethodError, 'execute! must be implemented by subclasses'
      end

      private

      attr_accessor :data
    end
  end
end
