# frozen_string_literal: true

module Game
  module Board
    # A 3-dimensional position on the game board
    class Position
      attr_accessor :x, :y, :z

      def initialize(x: 0, y: 0, z: 0)
        @x = x
        @y = y
        @z = z
      end

      def equals?(position)
        %i[x y z].all? { |axis| send(axis) == position.send(axis) }
      end

      def to_a
        [x, y, z]
      end

      def load(array)
        self.x, self.y, self.z = *array
      end
    end
  end
end
