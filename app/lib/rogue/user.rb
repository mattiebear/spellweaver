# frozen_string_literal: true

module Rogue
  class User
    attr_accessor :id, :image_url, :username

    def initialize(data = {})
      hydrate(data)
    end

    private

    def hydrate(data = {})
      data.symbolize_keys!

      %i[id image_url username].each do |key|
        send("#{key}=", data[key]) if data.key?(key)
      end
    end
  end
end
