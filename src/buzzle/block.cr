module Buzzle
  class Block < SpriteEntity
    getter? dead

    @respawn_x : Int32
    @respawn_y : Int32
    @respawn_z : Int32

    RESPAWN_TIMER = 3

    def initialize(x, y, z = 0)
      super(
        name: "block",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @moving_x = @moving_y = 0_f32
      @moving_amount = 0
      @dead = false
      @respawn_x = @x
      @respawn_y = @y
      @respawn_z = @z
      @respawn_timer = Timer.new(RESPAWN_TIMER)

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: -width / 2,
        origin_y: -height / 2,
        width: width * 2,
        height: height * 2
      )
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        center_y: false,
        x: x,
        y: y
      )
    end

    def collidable?
      !dead?
    end

    def liftable?
      true
    end

    def actionable?
      true
    end

    def update(frame_time, entities : Array(Entity))
      super

      moving_transition(frame_time, entities) if moving? && !lifting?

      if dead?
        if @respawn_timer.done?
          respawn
        else
          @respawn_timer.increase(frame_time)
        end
      end
    end

    def move_now(dx, dy, entities : Array(Entity))
      @x += dx
      @y += dy

      if !collision?(entities.select(&.traversable?)) || directional_collision?(entities.select(&.collidable?), Direction.from_delta(dx: dx.sign, dy: dy.sign))
        @x -= dx
        @y -= dy
      end
    end

    def move(dx = 0, dy = 0, amount = 2)
      return if lifting?

      @moving_amount = amount
      @moving_x = dx.to_f32 * @moving_amount
      @moving_y = dy.to_f32 * @moving_amount
    end

    def moving?
      return false if lifting?

      @moving_x.abs > 0 || @moving_y.abs > 0
    end

    def stop
      @moving_x = 0_f32
      @moving_y = 0_f32
    end

    def moving_transition(frame_time, entities)
      dx = @moving_x.sign * @moving_amount
      dy = @moving_y.sign * @moving_amount

      @moving_x += dx
      @x += dx

      @moving_y += dy
      @y += dy

      # stop moving at next grid cell
      if @moving_x.abs > Game::GRID_SIZE || @moving_y.abs > Game::GRID_SIZE
        stop

        ice_floors = entities.select(&.is_a?(Floor::Base)).map(&.as(Floor::Base)).select(&.block_slide?)

        # if we're on ice, slide again
        if collision?(ice_floors)
          @x += dx.sign * Game::GRID_SIZE
          @y += dy.sign * Game::GRID_SIZE

          direction = Direction.from_delta(dx: dx.sign, dy: dy.sign)

          if collision?(ice_floors) && !directional_collision?(entities.select(&.collidable?), direction)
            move(dx: dx.sign, dy: dy.sign, amount: @moving_amount)
          end

          @x -= dx.sign * Game::GRID_SIZE
          @y -= dy.sign * Game::GRID_SIZE
        end
      end
    end

    def die
      hide
      @dead = true
    end

    def respawn
      if hidden?
        show

        @source_height = 0

        @x = @respawn_x
        @y = @respawn_y + height
        @z = @respawn_z
      else
        @source_height.try { |h| @source_height = h + 1 }
        @y -= 1

        if @source_height.try { |h| h >= height }
          @source_height = nil
          @respawn_timer.reset
          @dead = false
        end
      end
    end
  end
end
