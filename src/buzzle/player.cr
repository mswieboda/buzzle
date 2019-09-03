module Buzzle
  class Player < SpriteEntity
    getter? falling
    property exit_door : Door | Nil

    @actionable : Entity | Nil
    @held_block : Block | Nil
    @sounds : Array(LibRay::Sound)

    MOVING_AMOUNT = 2

    MOVE_BLOCK_TIMER = 0.25

    FPS         = 12
    FALLING_FPS = 12

    MOVING_FRAME_LAST  = 2
    FALLING_FRAME_LAST = 5

    def initialize(x, y, z = 0)
      super(
        name: "player",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @moving_x = @moving_y = 0_f32
      @moving_left_foot = false
      @frame_t = 0_f32
      @falling = false
      @move_block_timer = Timer.new(MOVE_BLOCK_TIMER)

      @sounds = [
        Sound.get("footstep-1"),
        Sound.get("footstep-2"),
        Sound.get("footstep-3"),
        Sound.get("footstep-4"),
      ]
    end

    def update(frame_time, entities : Array(Entity))
      super

      @move_block_timer.reset if @move_block_timer.done?
      @move_block_timer.increase(frame_time) if @move_block_timer.started?

      unless moving?
        actionable(entities)
        movement_input(frame_time, entities)
        transitions(frame_time)
      end

      moving_transition(frame_time, entities) if moving?
    end

    def actionable(entities)
      pressed = Keys.pressed?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
      down = Keys.down?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])

      if pressed
        @actionable = entities.select(&.actionable?).find(&.trigger_facing?(self))

        # action
        @actionable.try(&.action) if @actionable
      elsif down && @actionable && @actionable.is_a?(Block)
        @held_block = @actionable.as(Block)
      elsif Keys.released?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
        @actionable = @held_block = nil
      end
    end

    def movement_input(frame_time, entities)
      dx = dy = 0

      if Keys.down?([LibRay::KEY_W, LibRay::KEY_UP])
        dy = -1
        @direction = Direction::Up unless @held_block
      elsif Keys.down?([LibRay::KEY_A, LibRay::KEY_LEFT])
        dx = -1
        @direction = Direction::Left unless @held_block
      elsif Keys.down?([LibRay::KEY_S, LibRay::KEY_DOWN])
        dy = 1
        @direction = Direction::Down unless @held_block
      elsif Keys.down?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        dx = 1
        @direction = Direction::Right unless @held_block
      end

      # if attempting to move (delta != 0)
      if dx != 0 || dy != 0
        @x += dx * Game::GRID_SIZE
        @y += dy * Game::GRID_SIZE

        if collision?(entities.select { |e| e.is_a?(Floor) || e.is_a?(Door) })
          if pushing_block?(dx, dy)
            @held_block.try(&.move(dx * Game::GRID_SIZE, dy * Game::GRID_SIZE, direction, entities)) if !@move_block_timer.started?
          end

          unless directional_collision?(entities.select(&.collidable?), pulling_block?(dx, dy) ? direction.opposite : direction)
            @moving_x = dx.to_f32 * MOVING_AMOUNT
            @moving_y = dy.to_f32 * MOVING_AMOUNT
          end
        end

        @x -= dx * Game::GRID_SIZE
        @y -= dy * Game::GRID_SIZE

        if pushing_block?(dx, dy)
          @held_block.try(&.move(-dx * Game::GRID_SIZE, -dy * Game::GRID_SIZE, direction, entities)) if !@move_block_timer.started?
        end
      end
    end

    def transitions(frame_time)
      if falling?
        @frame_t += frame_time

        if frame >= FALLING_FRAME_LAST + 1
          @falling = false
          remove
        end
      end
    end

    def moving?
      return false if falling?
      @moving_x.abs > 0 || @moving_y.abs > 0
    end

    def moving_transition(frame_time, entities)
      dx = @moving_x.sign * MOVING_AMOUNT
      dy = @moving_y.sign * MOVING_AMOUNT

      if pushing_block?(dx, dy)
        # push block
        @held_block.try(&.move(dx, dy, direction, entities)) if !@move_block_timer.started?
      elsif pulling_block?(dx, dy) && @move_block_timer.started?
        # stop, and don't pull while move block timer active
        stop
        return
      elsif @held_block && !pulling_block?(dx, dy)
        # trying to strafe while holding block, stop moving!
        stop
        return
      end

      if @moving_x == dx && @moving_y == dy
        # alternate foot step animation frame
        @moving_left_foot = !@moving_left_foot
      end

      @moving_x += dx
      @x += dx

      @moving_y += dy
      @y += dy

      if pulling_block?(dx, dy)
        # pull block
        @held_block.try(&.move(dx, dy, direction, entities)) if !@move_block_timer.started?
      end

      # stop moving at next grid cell
      if @moving_x.abs > Game::GRID_SIZE || @moving_y.abs > Game::GRID_SIZE
        stop
        Sound.play_random_pitch(@sounds.sample)
      end
    end

    def stop
      @moving_x = 0_f32
      @moving_y = 0_f32
      @move_block_timer.start if @held_block && !@move_block_timer.started?
      @held_block = nil

      if @exit_door
        @exit_door.try(&.done_exiting)
        @exit_door = nil
      end
    end

    def frame
      if moving?
        @moving_left_foot ? 1 : 2
      elsif falling?
        MOVING_FRAME_LAST + (@frame_t * fps).to_i
      else
        0
      end
    end

    def frame=(frame)
      @frame_t = frame.to_f32 / fps
    end

    def fps
      if falling?
        FALLING_FPS
      else
        FPS
      end
    end

    def row
      direction.to_i
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame,
        row: row
      )
    end

    def pushing_block?(dx, dy)
      return false unless @held_block
      [dx.sign, dy.sign] == direction.to_delta
    end

    def pulling_block?(dx, dy)
      return false unless @held_block
      [dx.sign, dy.sign] == direction.opposite.to_delta
    end

    def enter(door : Door, instant = false)
      return if door.switching?

      stop

      door.open(instant: instant) if door.closed?

      return unless instant

      door.exit

      @x = door.x
      @y = door.y

      exit(door)
    end

    def exit(door : Door)
      @direction = door.direction

      dx, dy = @direction.to_delta

      @moving_x = dx.to_f32 * MOVING_AMOUNT
      @moving_y = dy.to_f32 * MOVING_AMOUNT

      @exit_door = door
    end

    def fall
      stop
      @falling = true
      @frame_t = 0
    end

    def ascend
      @z += 1
    end

    def descend
      @z -= 1
    end

    def lift_ascend
      return if moving?

      ascend
      @moving_y = -1_f32 * MOVING_AMOUNT
    end

    def lift_descend
      return if moving?

      descend
      @moving_y = 1_f32 * MOVING_AMOUNT
    end
  end
end
