# frozen_string_literal: true

module Story
  class Message
    attr_reader :event, :data

    def initialize(event, data)
      @event = event
      @data = data
    end

    def get(key)
      data[key]
    end

    def to_h
      parcel.deep_transform_keys { |key| key.to_s.camelize(:lower) }
    end

    class << self
      def from(data = {})
        data = data.deep_transform_keys { |key| key.underscore.to_sym }

        new(data[:event], data[:data])
      end
    end

    private

    attr_writer :event, :data

    def parcel
      {
        event:,
        data: compose_data
      }
    end

    def compose_data
      if data.respond_to?(:to_h)
        data.to_h
      else
        data
      end
    end
  end
end
