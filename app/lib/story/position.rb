# frozen_string_literal: true

module Story
  class Position
    attr_accessor :x, :y, :z

    def initialize(x = 0, y = 0, z = 0)
      @x = x
      @y = y
      @z = z
    end

    def to_h
      { x:, y:, z: }
    end

    def equals?(position)
      x == position.x && y == position.y && z == position.z
    end

    class << self
      def parse(data)
        sym_data = data.symbolize_keys

        new(sym_data[:x], sym_data[:y], sym_data[:z])
      end
    end
  end
end
