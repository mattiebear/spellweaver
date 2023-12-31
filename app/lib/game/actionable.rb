# frozen_string_literal: true

module Game
  module Actionable
    extend ActiveSupport::Concern

    included do
      private 

      def fetch_action(key)
        self.class.actors[key]
      end
    end

    class_methods do
      attr_accessor :actors

      def register_action(event, klass)
        self.actors ||= {}

        actors[event] = klass
      end
    end
  end
end
