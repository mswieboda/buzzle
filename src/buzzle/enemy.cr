module Buzzle
  class Enemy < SpriteEntity
    getter? dead

    FPS = 12

    def initialize(sprite, @tint : Color = Color::White)
      super(
        sprite: sprite,
        x: 0,
        y: 0,
        z: 0,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @moving_left_foot = false
      @frame_t = 0_f32
      @dead = false
    end

    def update(frame_time, entities : Array(Entity))
      super

      movement(frame_time, entities)
    end

    def movement(frame_time, entities)
      return if dead?
    end

    def moving?
      false
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

    def initial_location(x = 0, y = 0, z = 0)
      @x = x * Game::GRID_SIZE
      @y = y * Game::GRID_SIZE
      @z = z
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
