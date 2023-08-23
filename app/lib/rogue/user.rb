# frozen_string_literal: true

module Rogue
  class User
    attr_accessor :id, :image_url, :username

    def initialize(data = {})
      hydrate(data)
    end

    def valid?
      attributes.all? { |attr| send(attr).present? }
    end

    private

    def hydrate(data = {})
      data.symbolize_keys!

      attributes.each do |key|
        send("#{key}=", data[key]) if data.key?(key)
      end
    end

    def attributes
      %i[id image_url username]
    end
  end
end
