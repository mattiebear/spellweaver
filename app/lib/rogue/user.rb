# frozen_string_literal: true

module Rogue
  class User
    attr_accessor :id, :image_url, :username

    def initialize(data = {})
      hydrate(data)

      return if id.present? && image_url.present? && username.present?

      load!
    end

    def load!
      data = UserClient.new.find_one_raw(user_id: id)

      hydrate(data)

      self
    end

    def self.from_jwt(data = {})
      new(id: data[:sub])
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
