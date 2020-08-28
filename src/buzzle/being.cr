module Buzzle
  abstract class Being < SpriteEntity
    getter? falling
    getter? dead
    property exit_door : Door::Base | Nil
    getter items

    @actionable : Entity | Nil
    @held_block : Block | Nil
    @sounds : Array(Sound)

    MOVING_AMOUNT = 2

    MOVE_BLOCK_TIMER = 0.25

    FPS         = 12
    FALLING_FPS = 12

    MOVING_FRAME_LAST  = 2
    FALLING_FRAME_LAST = 5

    def initialize(sprite, @tint : Color = Color::White)
      super(
        sprite: sprite,
        x: 0,
        y: 0,
        z: 0,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @moving_x = @moving_y = 0_f32
      @moving_left_foot = false
      @frame_t = 0_f32
      @falling = false
      @dead = false
      @move_block_timer = Timer.new(MOVE_BLOCK_TIMER)

      @sounds = [
        Sound.get("footstep-1"),
        Sound.get("footstep-2"),
        Sound.get("footstep-3"),
        Sound.get("footstep-4"),
      ]

      @items = [] of Item::Base
    end

    def update(frame_time, entities : Array(Entity))
      super

      movement(frame_time, entities)
    end

    def movement(frame_time, entities)
      return if dead? || lifting?

      @move_block_timer.reset if @move_block_timer.done?
      @move_block_timer.increase(frame_time) if @move_block_timer.started?

      unless moving? || lifting?
        actionable(entities) unless falling?
        movement_input(frame_time, entities) unless falling?
        transitions(frame_time)
      end

      moving_transition(frame_time, entities) if moving? && !lifting?
    end

    def actionable(entities)
      # TODO: do for NPC
    end

    def movement_input(frame_time, entities)
      # TODO: do for NPC
    end

    def transitions(frame_time)
      if falling?
        @frame_t += frame_time

        if frame >= FALLING_FRAME_LAST + 1
          @falling = false
          @frame_t = 0_f32
          die
        end
      end
    end

    def move(dx = 0, dy = 0)
      @moving_x = dx.to_f32 * MOVING_AMOUNT
      @moving_y = dy.to_f32 * MOVING_AMOUNT
    end

    def moving?
      return false if falling?
      return false if lifting?
      @moving_x.abs > 0 || @moving_y.abs > 0
    end

    def moving_transition(frame_time, entities)
      dx = @moving_x.sign * MOVING_AMOUNT
      dy = @moving_y.sign * MOVING_AMOUNT

      if pulling_block?(dx, dy) && @move_block_timer.started?
        # stop, and don't pull while move block timer active
        stop
        return
      elsif @held_block && !pushing_block?(dx, dy) && !pulling_block?(dx, dy)
        # trying to strafe while holding block, stop moving!
        stop
        return
      end

      if @moving_x == dx && @moving_y == dy
        # alternate foot step animation frame
        @moving_left_foot = !@moving_left_foot
      end

      @x += dx
      @moving_x += dx

      @y += dy
      @moving_y += dy

      # stop moving at next grid cell
      if @moving_x.abs > Game::GRID_SIZE || @moving_y.abs > Game::GRID_SIZE
        stop

        sound = @sounds.sample
        sound.randomize_pitch
        sound.play
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
      return if dead?

      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame,
        row: row,
        tint: @tint
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

    def enter(door : Door::Base, instant = false)
      return if !instant && door.switching?

      stop

      door.open(instant: instant) if door.closed?

      return if !instant && door.closed?

      door.exit

      @x = door.x
      @y = door.y

      @direction = door.direction

      dx, dy = @direction.to_delta

      @moving_x = dx.to_f32 * MOVING_AMOUNT
      @moving_y = dy.to_f32 * MOVING_AMOUNT

      @exit_door = door
    end

    def initial_location(x = 0, y = 0, z = 0)
      @x = x
      @y = y
      @z = z
    end

    def light_source?
      true
    end

    def light_radius
      -1
    end

    def light_shadow_extension
      2
    end

    def fall
      stop
      @falling = true
      @frame_t = 0
    end

    def liftable?
      true
    end

    def die
      @dead = true
    end

    def revive
      @dead = false
    end

    def face(direction : Direction)
      @direction = direction
    end
  end
end
