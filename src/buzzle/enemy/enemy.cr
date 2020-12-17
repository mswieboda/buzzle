module Buzzle
  abstract class Enemy < SpriteEntity
    getter? dead

    FPS = 12

    def initialize(sprite, x = 0, y = 0, z = 0, direction = Direction::Down, @tint : Color = Color::White)
      super(
        sprite: sprite,
        x: x,
        y: y,
        z: z,
        direction: direction,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: (-width / 2).to_i,
        origin_y: (-height / 2).to_i,
        width: width * 2,
        height: height * 2
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
      FPS
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

    def actionable?
      true
    end

    def action(player : Player)
      face(player)

      # TODO: turn based fight sequence
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
