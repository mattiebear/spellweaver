# frozen_string_literal: true

module Story
  class Book
    TRACKED_ATTRIBUTES = %i[map_id].freeze

    def initialize(game_session)
      self.id = get_id(game_session)
      self.map_id = nil
    end

    def save!
      TRACKED_ATTRIBUTES.each { |attr| save_field(attr) }
      self
    end

    def load!
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

    private

    attr_accessor :id, :map_id

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
