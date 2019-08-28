module Buzzle
  class Entity
    getter x : Float32
    getter y : Float32
    getter width : Int32
    getter height : Int32

    def initialize(x : Int32 | Float32, y : Int32 | Float32, @width, @height)
      @x = x.to_f32
      @y = y.to_f32
    end

    def update(frame_time)
    end

    def draw
    end

    def at?(other_x, other_y)
      x == other_x && y == other_y
    end

    def actionable?
      false
    end

    def action
    end

    def to_s(io)
      io << "#{super.to_s(io)} (#{x}, #{y}) (#{width}x#{height})"
    end

    def collisions?(entities : Array(Entity))
      entities.reject { |e| e == self }.any? { |entity| collision?(entity) }
    end

    def collision?(entity : Entity)
      x + width > entity.x &&
        x < entity.x + entity.width &&
        y + height > entity.y &&
        y < entity.y + entity.height
    end
  end
end
