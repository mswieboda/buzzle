module Buzzle
  class Chest < SpriteEntity
    getter? open

    FPS = 12

    def initialize(x, y, z = 0)
      super(
        name: "chest",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @open = false
      @frame_t = 0_f32

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: 0,
        origin_y: height / 2,
        width: width,
        height: height
      )
    end

    def closed?
      !open?
    end

    def actionable?
      true
    end

    def actionable_condition?(entity : Entity)
      return false if open?

      super(entity)
    end

    def action
      open
    end

    def open
      return if open?

      @open = true
    end

    def frame
      (@frame_t * FPS).to_i
    end

    def update(frame_time)
      super

      @frame_t += frame_time if open? && frame + frame_time <= sprite.frames - 1
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end
  end
end
