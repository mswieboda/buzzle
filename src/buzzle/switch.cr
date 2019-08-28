module Buzzle
  class Switch < SpriteEntity
    getter? on : Bool
    getter? switching : Bool

    FPS = 12

    def initialize(x, y, @on = false)
      super("switch", x, y, Game::GRID_SIZE, Game::GRID_SIZE)

      @frame_t = 0_f32
      @switching = false

      self.frame = @sprite.frames - 1 if off?
    end

    def draw
      draw(frame: frame)
    end

    def update(frame_time)
      if switching?
        if on? && frame <= sprite.frames - 2
          @frame_t += frame_time

          if frame >= sprite.frames - 1
            @switching = false
            @on = false
          end
        elsif off? && frame >= 1
          @frame_t -= frame_time

          if frame <= 0
            @switching = false
            @on = true
          end
        end
      end
    end

    def actionable?
      true
    end

    def action
      switch
    end

    def frame
      (@frame_t * FPS).to_i
    end

    def frame=(frame)
      @frame_t = frame.to_f32 / FPS
    end

    def switch
      @switching = true
    end

    def off?
      !on?
    end
  end
end
