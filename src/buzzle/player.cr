module Buzzle
  class Player < SpriteEntity
    getter direction : Direction

    DRAW_SIZE_PADDING = 12

    def initialize(x, y, @direction = Direction::Up)
      super("player", x, y)
    end

    def update(frame_time, entities : Array(Entity))
      move(frame_time, entities)
    end

    def move(frame_time, entities)
      dx = dy = 0

      action = Keys.down?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])

      if Keys.pressed?([LibRay::KEY_W, LibRay::KEY_UP])
        dy = -1
        @direction = Direction::Up
      elsif Keys.pressed?([LibRay::KEY_A, LibRay::KEY_LEFT])
        dx = -1
        @direction = Direction::Left
      elsif Keys.pressed?([LibRay::KEY_S, LibRay::KEY_DOWN])
        dy = 1
        @direction = Direction::Down
      elsif Keys.pressed?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        dx = 1
        @direction = Direction::Right
      end

      if action && (dx != 0 || dy != 0)
        action_cell_x, action_cell_y = action_cell
        actionable_entity = entities.select(&.movable?).find(&.at?(action_cell_x, action_cell_y))
        actionable_entity.try(&.move(direction))
      end

      @x += dx
      @y += dy

      if collisions?(entities)
        @x -= dx
        @y -= dy
      end
    end

    def draw
      draw(row: direction.to_i)
    end

    def action_cell
      case direction
      when Direction::Up
        [x, y - 1]
      when Direction::Left
        [x - 1, y]
      when Direction::Down
        [x, y + 1]
      when Direction::Right
        [x + 1, y]
      else
        [x, y]
      end
    end
  end
end
