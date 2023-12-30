# frozen_string_literal: true

module Game
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
  end
end
