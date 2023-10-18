# frozen_string_literal: true

require 'securerandom'

module Story
  class Token
    TRACKED_ATTRIBUTES = %i[id user_id token_id x y z].freeze

    attr_accessor :id, :user_id, :token_id, :x, :y, :z

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

    def generate_id
      self.id = SecureRandom.uuid
    end
  end
end
