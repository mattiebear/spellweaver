# frozen_string_literal: true

module Game
  module Messaging
    # Converts a data object between inbound and outbound formats
    class DataTransformer
      attr_reader :data

      def initialize(data = nil)
        @data = data
      end

      def outbound
        @outbound ||= data.deep_transform_keys { |key| key.to_s.camelize(:lower) }
      end

      def inbound
        @inbound ||= data.deep_transform_keys { |key| key.underscore.to_sym }
      end
    end
  end
end
