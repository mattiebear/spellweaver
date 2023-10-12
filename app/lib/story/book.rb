# frozen_string_literal: true

module Story
  class Book
    TRACKED_ATTRIBUTES = %i[map_id].freeze

    # TODO: Optimize how data is stored. Should it be a single hash?
    def initialize(game_session)
      @id = get_id(game_session)
      @map_id = nil
      @tokens = {}
    end

    def save!
      # TODO: Only save changed data
      save_tokens
      TRACKED_ATTRIBUTES.each { |attr| save_field(attr) }
      self
    end

    def load!
      load_tokens
      TRACKED_ATTRIBUTES.each { |attr| load_field(attr) }
      self
    end

    def to_h
      data = {}

      TRACKED_ATTRIBUTES.map do |attr|
        data[attr] = send(attr)
      end

      data
    end

    def select_map(id)
      self.map_id = id
    end

    # TODO: Move to a #tokens class
    def add_token(id, data)
      tokens.store(id, data)
    end

    private

    attr_accessor :id, :map_id, :tokens

    def get_id(game_session)
      case game_session
      when GameSession
        game_session.id
      when String
        game_session
      else
        raise StandardError.new, 'Invalid game session passed to story'
      end
    end

    def store_key(field)
      "story:#{id}:#{field}"
    end

    def token_key(token_id)
      "story:#{id}:token:#{token_id}"
    end

    def tokens_pattern
      "story:#{id}:token:*"
    end

    def author
      Persist::Client.instance
    end

    def save_field(attr)
      data = send(attr)
      data = data.to_json if data.is_a?(Hash)

      author.set(store_key(attr), data)
    end

    def save_tokens
      tokens.each do |id, data|
        key = token_key(id)
        author.hset(key, data)
      end
    end

    def load_field(attr)
      key = store_key(attr)

      data = author.get(key)

      send("#{attr}=".to_sym, data)
    end

    def load_tokens
      keys = author.keys(tokens_pattern)

      keys.each do |key|
        data = author.hgetall(key).deep_symbolize_keys
        tokens.store(data[:id], data)
      end
    end
  end
end
