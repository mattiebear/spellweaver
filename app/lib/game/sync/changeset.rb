# frozen_string_literal: true

module Game
  module Sync
    # Describes a change to be made to the persisted game state
    class Changeset
      attr_reader :key, :type, :value

      def initialize(key:, type: :set, value: nil)
        @key = key
        @type = type
        @value = value
      end
    end
  end
end
