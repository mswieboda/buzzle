module Buzzle
  class Player < SpriteEntity
    getter direction : Direction

    @actionable : Entity | Nil
    @held_block : Block | Nil

    def initialize(x, y, @direction = Direction::Up)
      super("player", x, y)
    end

    def update(frame_time, entities : Array(Entity))
      original_direction = direction

      actionable(entities)
      movement(frame_time, entities)
    end

    def actionable(entities)
      pressed = Keys.pressed?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
      down = Keys.down?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])

      if pressed
        action_cell_x, action_cell_y = action_cell
        @actionable = entities.select(&.actionable?).find(&.at?(action_cell_x, action_cell_y))

        # action
        @actionable.try(&.action) if @actionable
      elsif down && @actionable && @actionable.is_a?(Block)
        @held_block = @actionable.as(Block)
      elsif Keys.released?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
        @actionable = @held_block = nil
      end
    end

    def movement(frame_time, entities)
      dx = dy = 0
      new_direction = direction

      if Keys.pressed?([LibRay::KEY_W, LibRay::KEY_UP])
        dy = -1
        new_direction = Direction::Up
      elsif Keys.pressed?([LibRay::KEY_A, LibRay::KEY_LEFT])
        dx = -1
        new_direction = Direction::Left
      elsif Keys.pressed?([LibRay::KEY_S, LibRay::KEY_DOWN])
        dy = 1
        new_direction = Direction::Down
      elsif Keys.pressed?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        dx = 1
        new_direction = Direction::Right
      end

      if @held_block && (dx != 0 || dy != 0)
        if new_direction == direction
          # push
          @held_block.try(&.move(entities, direction))
        elsif !new_direction.opposite?(direction)
          # trying to push/pull sideways, don't move!
          return
        end
      end

      @x += dx
      @y += dy

      if collisions?(entities)
        @x -= dx
        @y -= dy
      end

      if @held_block && (dx != 0 || dy != 0) && new_direction.opposite?(direction)
        # pull
        @held_block.try(&.move(entities, new_direction))
      end

      @direction = new_direction unless @held_block
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
