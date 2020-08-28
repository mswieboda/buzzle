module Buzzle
  abstract class Obj
    getter x : Int32
    getter y : Int32
    getter z : Int32
    getter width : Int32
    getter height : Int32
    getter direction : Direction
    getter? removed
    getter? hidden

    def initialize(x : Int32, y : Int32, @z = 0, @width : Int32 = 0, @height : Int32 = 0, @direction = Direction::Down, @hidden = false)
      @x = x * Game::GRID_SIZE
      @y = y * Game::GRID_SIZE
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

    def hide
      @hidden = true
    end

    def show
      @hidden = false
    end

    def layer
      3
    end

    def collidable?
      true
    end

    def facing?(entity : Entity, opposite = false)
      direction = opposite ? @direction.opposite : @direction

      (
        (y >= entity.y && y < entity.y + entity.height && y + height > entity.y && y < entity.y + entity.height) &&
          (
            (x >= entity.x + entity.width && direction.left?) ||
              (x + width <= entity.x && direction.right?)
          )
      ) ||
        (
          (x >= entity.x && x < entity.x + entity.width && x + width > entity.x && x < entity.x + entity.width) &&
            (
              (y >= entity.y + entity.height && direction.up?) ||
                (y >= entity.y && y + height <= entity.y + entity.height && direction.up?) ||
                (y + height <= entity.y && direction.down?)
            )
        )
    end

    def face(entity)
      # up/down
      if y >= entity.y + entity.height
        if horz_between?(entity) || vert_distance_longer?(entity)
          @direction = Direction::Up
          return
        end
      elsif y + height <= entity.y
        if horz_between?(entity) || vert_distance_longer?(entity)
          @direction = Direction::Down
          return
        end
      end

      # left/right
      if x >= entity.x + entity.width
        if vert_between?(entity) || horz_distance_longer?(entity)
          @direction = Direction::Left
        end
      elsif x + width <= entity.x
        if vert_between?(entity) || horz_distance_longer?(entity)
          @direction = Direction::Right
        end
      end
    end

    def horz_between?(entity)
      (x <= entity.x && x + width > entity.x) || (x <= entity.x + entity.width && x + width > entity.x)
    end

    def vert_between?(entity)
      (y <= entity.y && y + height > entity.y) || (y <= entity.y + entity.height && y + height > entity.y)
    end

    def horz_distance_longer?(entity)
      !vert_distance_longer?(entity)
    end

    def vert_distance_longer?(entity)
      y_d = entity.y + entity.height - y
      x_d = [entity.x - (x + width), x - (entity.x - entity.width)].max

      y_d >= x_d
    end

    def to_s(io)
      io << "#{super.to_s(io)} (#{x}, #{y}) (#{width}x#{height})"
    end

    def collisions(objs : Array(Obj))
      objs.reject { |o| o == self }.select { |o| collision?(o) }
    end

    def collision?(objs : Array(Obj))
      collision = false

      objs.reject { |o| o == self }.each do |o|
        return true if collision?(o)
      end

      collision
    end

    def collision?(obj : Obj)
      return false unless z == obj.z
      collision?(obj.x, obj.y, obj.width, obj.height)
    end

    def collision?(x, y, width, height)
      self.x < x + width &&
        self.x + self.width > x &&
        self.y < y + height &&
        self.y + self.height > y
    end

    def directional_collision?(objs : Array(Obj), direction : Direction)
      objs.reject { |o| o == self }.select { |o| o.directional_collision?(self, direction) }.any?
    end

    def directional_collision?(obj : Obj, direction : Direction)
      collision?(obj)
    end

    def remove
      @removed = true
    end
  end
end
