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
        tokens.store(data[:id], Token.load(data))
      end
    end

    def save!
      tokens.each do |id, token|
        author.hset(token_key(id), token.to_h)
      end
    end

    def to_h
      tokens.map { |_, token| token.to_h }
    end

    def token_at?(position)
      tokens.values.any? { |token| token.at?(position) }
    end

    def with_id?(token_id)
      tokens.key?(token_id)
    end

    def add(data, user)
      position = Position.new(*data[:pos])

      token = Token.new(user_id: user.id, token_id: data[:token_id], position:)

      tokens.store(token.id, token)

      token
    end

    def remove(token_id)
      tokens.delete(token_id)
      author.del(token_key(token_id))
    end

    def move(token_id, position)
      token = tokens[token_id]
      token.move_to(position)

      author.hset(token_key(token_id), token.to_h)

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
