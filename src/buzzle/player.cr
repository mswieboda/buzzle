module Buzzle
  class Player < SpriteEntity
    getter direction : Direction

    def initialize(x, y, @direction = Direction::Up)
      super("player", x, y)
    end

    def update(frame_time, entities : Array(Entity))
      movement(frame_time, entities)
    end

    def movement(frame_time, entities)
      dx = dy = 0
      original_direction = direction

      actionable = nil
      held_block = nil

      action_cell_x, action_cell_y = action_cell
      actionable = entities.select(&.actionable?).find(&.at?(action_cell_x, action_cell_y))

      if actionable && Keys.down?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
        held_block = actionable.as(Block) if actionable.is_a?(Block)
      end

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
      elsif actionable && Keys.pressed?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
        actionable.try(&.action)
      end

      if held_block && (dx != 0 || dy != 0)
        if direction == original_direction
          # push
          held_block.move(entities, direction)
        elsif !direction.opposite?(original_direction)
          @direction = original_direction
          return
        end
      end

      @x += dx
      @y += dy

      if collisions?(entities)
        @x -= dx
        @y -= dy
      end

      if held_block && (dx != 0 || dy != 0) && direction.opposite?(original_direction)
        # pull
        held_block.try(&.move(entities, direction))
        @direction = original_direction
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
