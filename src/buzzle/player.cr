module Buzzle
  class Player < Being
    def initialize
      super(sprite: "player")
    end

    def movement(frame_time, entities)
      return if Game.pause_player_input?

      super
    end

    def actionable(entities)
      pressed = Keys.pressed?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
      down = Keys.down?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])

      @actionable = entities.select(&.actionable?).find(&.actionable_condition?(self)) if pressed || down

      if pressed
        # action
        @actionable.try(&.action(self)) if @actionable
      elsif down
        @held_block = nil
        @held_block = @actionable.as(Block) if @actionable && @actionable.is_a?(Block) && !@actionable.try(&.lifting?)
      elsif Keys.released?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
        @actionable = @held_block = nil
      end
    end

    def movement_input(frame_time, entities)
      old_direction = @direction
      dx = dy = 0

      if Keys.down?([LibRay::KEY_W, LibRay::KEY_UP])
        @direction = Direction::Up
      elsif Keys.down?([LibRay::KEY_A, LibRay::KEY_LEFT])
        @direction = Direction::Left
      elsif Keys.down?([LibRay::KEY_S, LibRay::KEY_DOWN])
        @direction = Direction::Down
      elsif Keys.down?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        @direction = Direction::Right
      end

      return unless old_direction == direction

      if Keys.down?([LibRay::KEY_W, LibRay::KEY_UP, LibRay::KEY_A, LibRay::KEY_LEFT, LibRay::KEY_S, LibRay::KEY_DOWN, LibRay::KEY_D, LibRay::KEY_RIGHT])
        dx, dy = direction.to_delta
      end

      return if dx.zero? && dy.zero?

      # release block if trying to pull on ice
      if pulling_block?(dx, dy) && collision?(entities.select(&.is_a?(Floor::Base)).map(&.as(Floor::Base)).select(&.block_slide?))
        @held_block = nil
      end

      @x += dx * Game::GRID_SIZE
      @y += dy * Game::GRID_SIZE

      if collision?(entities.select(&.traversable?))
        if pushing_block?(dx, dy)
          @held_block.try(&.move_now(dx * Game::GRID_SIZE, dy * Game::GRID_SIZE, entities)) if !@move_block_timer.started?
        end

        unless directional_collision?(entities.select(&.collidable?), pulling_block?(dx, dy) ? direction.opposite : direction)
          move(dx: dx, dy: dy)

          if (pushing_block?(dx, dy) || pulling_block?(dx, dy)) && !@move_block_timer.started?
            @held_block.try(&.move(dx: dx, dy: dy, amount: MOVING_AMOUNT))
          end
        end
      end

      @x -= dx * Game::GRID_SIZE
      @y -= dy * Game::GRID_SIZE

      if pushing_block?(dx, dy)
        @held_block.try(&.move_now(-dx * Game::GRID_SIZE, -dy * Game::GRID_SIZE, entities)) if !@move_block_timer.started?
      end
    end

    def receive_item(item : Item::Base)
      @items << item
      item.hide
      item
    end

    def use_item?(item_class : Class)
      item = @items.find { |item| item.class == item_class }

      if item
        item.remove
        !!@items.delete(item)
      else
        false
      end
    end
  end
end
