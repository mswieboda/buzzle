module Buzzle
  class Entity
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    def initialize(@x, @y, @width = 1, @height = 1)
    end

    def update(frame_time)
    end

    def draw
    end

    def at?(other_x, other_y)
      x == other_x && y == other_y
    end

    def collidable?
      true
    end

    def to_s_coords
      "(#{x}, #{y})"
    end

    def collisions?(entities : Array(Entity))
      # puts entities.map(&.to_s_coords).join(", ")
      entities.any? { |entity| collision?(entity) }
    end

    def collision?(entity : Entity)
      x + (width - 1) >= entity.x &&
        x <= entity.x + (width - 1) &&
        y + (height - 1) >= entity.y &&
        y <= entity.y + (height - 1)
    end
  end
end
