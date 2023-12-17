# frozen_string_literal: true

require 'securerandom'

module Story
  class Token
    attr_accessor :id, :user_id, :token_id, :position

    def initialize(user_id:, token_id:, position:, id: nil)
      @id = id
      @user_id = user_id
      @token_id = token_id
      @position = position

      generate_id if id.blank?
    end

    def data
      {
        id:,
        user_id:,
        token_id:,
        **position.to_h
      }
    end

    def to_h
      {
        id:,
        user_id:,
        token_id:,
        pos: position.to_a
      }
    end

    def at?(position)
      self.position.equals?(position)
    end

    def move_to(position)
      self.position = position
    end

    class << self
      def load(data)
        sym_data = data.symbolize_keys

        position = Position.new(sym_data[:x].to_i, sym_data[:y].to_i, sym_data[:z].to_i)

        new(user_id: sym_data[:user_id], token_id: sym_data[:token_id], position:, id: sym_data[:id])
      end
    end

    private

    def generate_id
      self.id = SecureRandom.uuid
    end
  end
end
