module Buzzle
  class Obj
    getter x : Float32
    getter y : Float32
    getter z : Int32
    getter width : Int32
    getter height : Int32
    getter direction : Direction
    getter? removed

    def initialize(x : Int32 | Float32, y : Int32 | Float32, @z = 0, @width = 0, @height = 0, @direction = Direction::Down)
      @x = x.to_f32 * Game::GRID_SIZE
      @y = y.to_f32 * Game::GRID_SIZE
      @removed = false
    end

    def update(frame_time, _entities)
      update(frame_time)
    end

    def update(_frame_time)
    end

    def draw(_screen_x, _screen_y)
    end

    def draw_sort(obj : Obj)
      z_test = z <=> obj.z
      return z_test unless z_test.zero?

      l_test = layer <=> obj.layer
      return l_test unless l_test.zero?

      y <=> obj.y
    end

    def layer
      2
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

    def collisions(objs : Array(Obj))
      objs.reject { |o| o == self }.select { |o| collision?(o) }
    end

    def collision?(objs : Array(Obj))
      collisions(objs).any?
    end

    def collision?(obj : Obj)
      return false unless z == obj.z
      return false unless x + width > obj.x &&
        x < obj.x + obj.width &&
        y + height > obj.y &&
        y < obj.y + obj.height
      obj.directional_collision?(direction)
    end

    def directional_collision?(obj_direction : Direction)
      false
    end

    def remove
      @removed = true
    end
  end
end
