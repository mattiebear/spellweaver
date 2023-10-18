# frozen_string_literal: true

require 'securerandom'

module Story
  class Token
    TRACKED_ATTRIBUTES = %i[id user_id token_id x y z].freeze

    attr_accessor :id, :user_id, :token_id
    attr_reader :x, :y, :z

    def initialize(data = {})
      data.symbolize_keys!

      TRACKED_ATTRIBUTES.each do |attr|
        value = data[attr]

        send("#{attr}=".to_sym, value)
      end

      generate_id if id.blank?
    end

    def to_h
      data = {}

      TRACKED_ATTRIBUTES.map do |attr|
        data[attr] = send(attr)
      end

      data
    end

    def position
      Position.new(x, y, z)
    end

    def at?(position)
      self.position.equals?(position)
    end

    private

    def generate_id
      self.id = SecureRandom.uuid
    end

    def x=(value)
      @x = value.to_i
    end

    def y=(value)
      @y = value.to_i
    end

    def z=(value)
      @z = value.to_i
    end
  end
end
