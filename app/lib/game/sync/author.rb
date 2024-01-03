# frozen_string_literal: true

module Game
  module Sync
    # Saves and loads fields into the database
    class Author
      include Dry::Monads[:result]

      def initialize(prefix = nil)
        @prefix = prefix
      end

      def load(key)
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

      def apply(state)
        apply_change(state.changes.shift) while state.changes.any?

        Success(state)
      end

      private

      attr_reader :prefix

      def client
        Persist::Client.instance
      end

      def prefix_string
        keystore(prefix)
      end

      def full_key(key)
        [prefix_string, keystore(key)].filter(&:present?).join(':')
      end

      def keystore(key)
        if key.is_a?(Array)
          key.map { |k| keystore(k) }.join(':')
        else
          key.to_s
        end
      end

      def apply_change(changeset)
        case changeset.type
        when :set
          save(changeset.key, changeset.value)
        when :delete
          remove(changeset.key)
        end
      end
    end
  end
end
