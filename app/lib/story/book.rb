# frozen_string_literal: true

module Story
  class Book
    TRACKED_ATTRIBUTES = %i[map_id].freeze

    def initialize(game_session, user)
      @game_session = game_session
      @map_id = nil
      @tokens = TokenMap.new(id)
      @user = user
    end

    def save!
      tokens.save!
      TRACKED_ATTRIBUTES.each { |attr| save_field(attr) }
      self
    end

    def load!
      tokens.load!
      TRACKED_ATTRIBUTES.each { |attr| load_field(attr) }
      self
    end

    def to_h
      data = {
        tokens: tokens.to_h
      }

      TRACKED_ATTRIBUTES.map do |attr|
        data[attr] = send(attr)
      end

      data
    end

    def select_map(id)
      self.map_id = id
    end

    def add_token(data)
      position = Position.new(*data[:pos])

      return nil if tokens.token_at?(position)
      return nil if game_session.player?(user) && tokens.with_user?(user.id)

      tokens.add(data, user)
    end

    def remove_token(token_id)
      return false unless tokens.with_id?(token_id)
      return false unless tokens.get(token_id).user_id == user.id

      tokens.remove(token_id)
    end

    def move_token(data)
      new_position = Position.new(*data[:pos])

      return nil if tokens.token_at?(new_position) || !tokens.with_id?(data[:token_id]) || tokens.get(data[:token_id]).user_id != user.id

      tokens.move(data[:token_id], new_position)
    end

    private

    attr_accessor :game_session, :map_id, :tokens, :user

    def id
      game_session.id
    end

    def store_key(field)
      "story:#{id}:#{field}"
    end

    def author
      Persist::Client.instance
    end

    def save_field(attr)
      data = send(attr)
      data = data.to_json if data.is_a?(Hash)

      author.set(store_key(attr), data)
    end

    def load_field(attr)
      key = store_key(attr)

      data = author.get(key)

      send("#{attr}=".to_sym, data)
    end
  end
end
