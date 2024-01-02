# frozen_string_literal: true

module Game
  module Sync
    # Saves and loads fields into the database
    class Author
      def initialize(prefix = nil)
        @prefix = prefix
      end
    end

    def load(key)
      client.get(full_key(key))
    end

    def load_hash(key)
      data = client.hgetall(full_key(key))

      if block_given?
        yield(data)
      else
        data
      end
    end

    def load_each(pattern)
      keys = client.keys(full_key([pattern, '*']))

      keys.map do |key|
        data = client.hgetall(key)

        if block_given?
          yield(data)
        else
          data
        end
      end
    end

    def save(key, value)
      k = full_key(key)

      if value.is_a?(Hash)
        client.hset(k, value)
      else
        client.set(k, value)
      end
    end

    def remove(key)
      client.del(full_key(key))
    end

    private

    def client
      @client ||= Persist::Client.new
    end

    def prefix_string
      keystore(prefix)
    end

    def full_key(key)
      [prefix_string, keystore(key)].filter(&:present?).join(':')
    end

    def keystore(key)
      case key.class
      when String
        prefix
      when Symbol
        prefix.to_s
      when Array
        prefix.join(':')
      else
        ''
      end
    end
  end
end
