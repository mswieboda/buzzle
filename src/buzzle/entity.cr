module Buzzle
  class Entity
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    def initialize(@x, @y, @width, @height)
    end

    def update(frame_time)
    end

    def draw
    end

    def at?(other_x, other_y)
      x == other_x && y == other_y
    end

    def collision?(entity)
    end
  end
end
