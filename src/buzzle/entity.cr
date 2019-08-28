module Buzzle
  class Entity
    getter x : Float32
    getter y : Float32
    getter width : Int32
    getter height : Int32
    getter? removed

    def initialize(x : Int32 | Float32, y : Int32 | Float32, @width, @height)
      @x = x.to_f32
      @y = y.to_f32
      @removed = false
    end

    def update(frame_time, _entities)
      update(frame_time)
    end

    def update(_frame_time)
    end

    def draw
    end

    def trigger?(_entity : Entity)
    end

    def at?(other_x, other_y)
      x == other_x && y == other_y
    end

    def collidable?
      true
    end

    def actionable?
      false
    end

    def action
    end

    def to_s(io)
      io << "#{super.to_s(io)} (#{x}, #{y}) (#{width}x#{height})"
    end

    def collisions(entities : Array(Entity))
      entities.reject { |e| e == self }.select { |e| collision?(e) }
    end

    def collision?(entities : Array(Entity))
      collisions(entities).any?
    end

    def collision?(entity : Entity)
      x + width > entity.x &&
        x < entity.x + entity.width &&
        y + height > entity.y &&
        y < entity.y + entity.height
    end

    def remove
      @removed = true
    end
  end
end
