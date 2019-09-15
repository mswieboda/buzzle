module Buzzle
  class Enemy < SpriteEntity
    @tint : LibRay::Color

    MOVING_AMOUNT = 2

    FPS = 12

    def initialize(x, y, z = 0, width = Game::GRID_SIZE, height = Game::GRID_SIZE, @tint = LibRay::RED)
      super(
        name: "player",
        x: x,
        y: y,
        z: z,
        width: width,
        height: height
      )

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: -width / 2,
        origin_y: -height / 2,
        width: width * 2,
        height: height * 2
      )

      @moving_x = @moving_y = 0_f32
      @moving_left_foot = false
      @frame_t = 0_f32
    end

    def update(frame_time, entities : Array(Entity))
      super

      unless moving?
        movement_input(frame_time, entities)
      end

      moving_transition(frame_time, entities) if moving? && !lifting?
    end

    def movement_input(frame_time, entities)
      dx = dy = 0

      r = rand
      if r < 0.0125
        dx = rand > 0.5 ? -1 : 1
      elsif r < 0.025
        dy = rand > 0.5 ? -1 : 1
      end

      # if attempting to move (delta != 0)
      if dx != 0 || dy != 0
        @x += dx * Game::GRID_SIZE
        @y += dy * Game::GRID_SIZE

        if collision?(entities.select { |e| e.is_a?(Floor) })
          unless directional_collision?(entities.select(&.collidable?), direction)
            @moving_x = dx.to_f32 * MOVING_AMOUNT
            @moving_y = dy.to_f32 * MOVING_AMOUNT
          end
        end

        @x -= dx * Game::GRID_SIZE
        @y -= dy * Game::GRID_SIZE
      end
    end

    def moving_transition(frame_time, entities)
      dx = @moving_x.sign * MOVING_AMOUNT
      dy = @moving_y.sign * MOVING_AMOUNT

      if @moving_x == dx && @moving_y == dy
        # alternate foot step animation frame
        @moving_left_foot = !@moving_left_foot
      end

      @moving_x += dx
      @x += dx

      @moving_y += dy
      @y += dy

      # stop moving at next grid cell
      if @moving_x.abs > Game::GRID_SIZE || @moving_y.abs > Game::GRID_SIZE
        stop
      end
    end

    def moving?
      @moving_x.abs > 0 || @moving_y.abs > 0
    end

    def stop
      @moving_x = 0_f32
      @moving_y = 0_f32
    end

    def frame
      if moving?
        @moving_left_foot ? 1 : 2
      else
        0
      end
    end

    def frame=(frame)
      @frame_t = frame.to_f32 / fps
    end

    def fps
      FPS
    end

    def row
      direction.to_i
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame,
        row: row,
        tint: @tint
      )
    end
  end
end
