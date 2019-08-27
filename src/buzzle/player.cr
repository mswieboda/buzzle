module Buzzle
  class Player < SpriteEntity
    getter direction : Direction

    @actionable : Entity | Nil
    @held_block : Block | Nil

    MOVING_AMOUNT = 150

    def initialize(x, y, @direction = Direction::Up)
      super("player", x, y)

      @moving_x = @moving_y = 0_f32
    end

    def update(frame_time, entities : Array(Entity))
      original_direction = direction

      actionable(entities)
      # push
      # rename to movement_input
      movement(frame_time, entities)
      # move via @moving_x/y
      # pull
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
      dx = dy = 0_f32
      new_direction = direction
      pushing = false

      if Keys.down?([LibRay::KEY_W, LibRay::KEY_UP])
        dy = -MOVING_AMOUNT * frame_time
        new_direction = Direction::Up
      elsif Keys.down?([LibRay::KEY_A, LibRay::KEY_LEFT])
        dx = -MOVING_AMOUNT * frame_time
        new_direction = Direction::Left
      elsif Keys.down?([LibRay::KEY_S, LibRay::KEY_DOWN])
        dy = MOVING_AMOUNT * frame_time
        new_direction = Direction::Down
      elsif Keys.down?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        dx = MOVING_AMOUNT * frame_time
        new_direction = Direction::Right
      end
      
      # move to #push
      # if attempting to move (delta != 0)
      if dx != 0_f32 || dy != 0_f32
        if @held_block
          if new_direction == direction
            @held_block.try(&.move(dx, dy, entities))
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
        else
          # set @movable_x/y
        end

        # move to #pull
        if @held_block && new_direction.opposite?(direction)
          # pull
          @held_block.try(&.move(dx, dy, entities.reject { |e| e == self }))
        end
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
