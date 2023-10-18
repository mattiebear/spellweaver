# frozen_string_literal: true

module Story
  class TokenMap
    attr_reader :game_session_id, :tokens

    def initialize(game_session_id)
      @game_session_id = game_session_id
      @tokens = {}
    end

    def load!
      keys = author.keys(tokens_pattern)

      keys.each do |key|
        data = author.hgetall(key).deep_symbolize_keys
        tokens.store(data[:id], Token.new(data))
      end
    end

    def save!
      tokens.each do |id, token|
        key = token_key(id)
        author.hset(key, token.to_h)
      end
    end

    def to_h
      tokens.map { |_, token| token.to_h }
    end

    def token_at?(position)
      tokens.values.any? { |token| token.at?(position) }
    end

    def add(data)
      token = Token.new(data)

      tokens.store(token.id, token)

      token
    end

    private

    def author
      Persist::Client.instance
    end

    def tokens_pattern
      "story:#{game_session_id}:token:*"
    end

    def token_key(token_id)
      "story:#{game_session_id}:token:#{token_id}"
    end
  end
end
