# frozen_string_literal: true

require 'singleton'

module Persist
  class Client
    include Singleton

    delegate :del, :get, :hgetall, :hset, :keys, :set, to: :redis

    def initialize
      self.redis = Redis.new
    end

    private

    attr_accessor :redis
  end
end
