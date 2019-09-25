module Buzzle
  class Player < SpriteEntity
    getter? falling
    getter? dead
    property exit_door : Door::Base | Nil
    getter items

    @actionable : Entity | Nil
    @held_block : Block | Nil
    @sounds : Array(LibRay::Sound)

    MOVING_AMOUNT = 50

    MOVE_BLOCK_TIMER = 0.25

    FPS         = 12
    FALLING_FPS = 12

    MOVING_FRAME_LAST  = 2
    FALLING_FRAME_LAST = 5

    def initialize
      super(
        name: "player",
        x: 0,
        y: 0,
        z: 0,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @dir = Dir::South

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

      return if dead? || lifting?

      @move_block_timer.reset if @move_block_timer.done?
      @move_block_timer.increase(frame_time) if @move_block_timer.started?

      unless lifting?
        actionable(entities) unless falling?
        movement_input(frame_time, entities) unless falling?
        transitions(frame_time)
      end
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
      dx = dy = 0_f32

      dy = -1_f32 if Keys.down?([LibRay::KEY_W, LibRay::KEY_UP])
      dx = 1_f32 if Keys.down?([LibRay::KEY_D, LibRay::KEY_RIGHT])
      dy = 1_f32 if Keys.down?([LibRay::KEY_S, LibRay::KEY_DOWN])
      dx = -1_f32 if Keys.down?([LibRay::KEY_A, LibRay::KEY_LEFT])

      if dy == -1
        @direction = Direction::Up

        if dx == 1
          @dir = Dir::NorthEast
          dy *= 0.5_f32
          dx *= 0.5_f32
        elsif dx == -1
          @dir = Dir::NorthWest
          dy *= 0.5_f32
          dx *= 0.5_f32
        else
          @dir = Dir::North
        end
      elsif dy == 0
        if dx == 1
          @direction = Direction::Right
          @dir = Dir::East
        elsif dx == -1
          @direction = Direction::Left
          @dir = Dir::West
        end
      elsif dy == 1
        @direction = Direction::Down

        if dx == 1
          @dir = Dir::SouthEast
          dy *= 0.5_f32
          dx *= 0.5_f32
        elsif dx == -1
          @dir = Dir::SouthWest
          dy *= 0.5_f32
          dx *= 0.5_f32
        else
          @dir = Dir::South
        end
      end

      # if attempting to move (delta != 0)
      if dx != 0 || dy != 0
        # release block if trying to pull on ice
        if pulling_block?(dx, dy) && collision?(entities.select(&.is_a?(Floor::Base)).map(&.as(Floor::Base)).select(&.block_slide?))
          @held_block = nil
        end

        @x += dx.to_i
        @y += dy.to_i

        if collision?(entities.select(&.traversable?))
          # TODO: fix
          # if pushing_block?(dx, dy)
          #   @held_block.try(&.move_now(dx * Game::GRID_SIZE, dy * Game::GRID_SIZE, entities)) if !@move_block_timer.started?
          # end

          unless directional_collision?(entities.select(&.collidable?), pulling_block?(dx, dy) ? direction.opposite : direction)
            move(frame_time: frame_time, dx: dx, dy: dy)
            # TODO: fix
            # @held_block.try(&.move(dx: dx, dy: dy, amount: MOVING_AMOUNT)) if !@move_block_timer.started?
          end
        end

        @x -= dx.to_i
        @y -= dy.to_i

        # TODO: fix
        # if pushing_block?(dx, dy)
        #   @held_block.try(&.move_now(-dx * Game::GRID_SIZE, -dy * Game::GRID_SIZE, entities)) if !@move_block_timer.started?
        # end
      end
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

    def move(frame_time, dx, dy)
      @x += dx.to_f32 * MOVING_AMOUNT * frame_time
      @y += dy.to_f32 * MOVING_AMOUNT * frame_time
    end

    def moving?
      return false if falling?
      return false if lifting?
      false
    end

    def stop
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
      @dir.to_i
    end

    def draw(screen_x, screen_y)
      return if dead?

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

    def enter(door : Door::Base, instant = false)
      return if !instant && door.switching?

      stop

      door.open(instant: instant) if door.closed?

      return if !instant && door.closed?

      door.exit

      @x = door.x
      @y = door.y

      @direction = door.direction

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
