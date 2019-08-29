module Buzzle
  class Player < SpriteEntity
    getter direction : Direction
    getter? falling

    @actionable : Entity | Nil
    @held_block : Block | Nil
    @exit_door : Door | Nil
    @sounds : Array(LibRay::Sound)

    MOVING_AMOUNT = 2

    FPS         = 12
    FALLING_FPS = 12

    MOVING_FRAME_LAST  = 2
    FALLING_FRAME_LAST = 5

    def initialize(x, y, z = 0, @direction = Direction::Up)
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

      @sounds = [
        Sound.get("footstep-1"),
        Sound.get("footstep-2"),
        Sound.get("footstep-3"),
        Sound.get("footstep-4"),
      ]
    end

    def update(frame_time, entities : Array(Entity))
      super

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
      new_direction = direction

      if Keys.down?([LibRay::KEY_W, LibRay::KEY_UP])
        dy = -1
        new_direction = Direction::Up
      elsif Keys.down?([LibRay::KEY_A, LibRay::KEY_LEFT])
        dx = -1
        new_direction = Direction::Left
      elsif Keys.down?([LibRay::KEY_S, LibRay::KEY_DOWN])
        dy = 1
        new_direction = Direction::Down
      elsif Keys.down?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        dx = 1
        new_direction = Direction::Right
      end

      # if attempting to move (delta != 0)
      if dx != 0 || dy != 0
        @x += dx * Game::GRID_SIZE
        @y += dy * Game::GRID_SIZE

        if collision?(entities.select(&.is_a?(Floor)))
          if pushing_block?(dx, dy)
            @held_block.try(&.move(dx * Game::GRID_SIZE, dy * Game::GRID_SIZE, entities))
          end

          if collision?(entities.select(&.collidable?))
            @x -= dx * Game::GRID_SIZE
            @y -= dy * Game::GRID_SIZE

            if pushing_block?(dx, dy)
              @held_block.try(&.move(-dx * Game::GRID_SIZE, -dy * Game::GRID_SIZE, entities))
            end
          else
            @x -= dx * Game::GRID_SIZE
            @y -= dy * Game::GRID_SIZE

            if pushing_block?(dx, dy)
              @held_block.try(&.move(-dx * Game::GRID_SIZE, -dy * Game::GRID_SIZE, entities))
            end

            @moving_x = dx.to_f32 * MOVING_AMOUNT
            @moving_y = dy.to_f32 * MOVING_AMOUNT
            @moving_left_foot = !@moving_left_foot
          end
        else
          @x -= dx * Game::GRID_SIZE
          @y -= dy * Game::GRID_SIZE
        end
      end

      @direction = new_direction unless @held_block
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
      @moving_x.abs > 0 || @moving_y.abs > 0
    end

    def moving_transition(frame_time, entities)
      dx = @moving_x.sign * MOVING_AMOUNT
      dy = @moving_y.sign * MOVING_AMOUNT

      if pushing_block?(dx, dy)
        # push block
        @held_block.try(&.move(dx, dy, entities))
      elsif @held_block && !pulling_block?(dx, dy)
        # trying to strafe while holding block, stop moving!
        stop
        return
      end

      @moving_x += dx
      @x += dx

      @moving_y += dy
      @y += dy

      if pulling_block?(dx, dy)
        # pull block
        @held_block.try(&.move(dx, dy, entities))
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
  end
end
