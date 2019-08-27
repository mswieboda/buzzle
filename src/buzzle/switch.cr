module Buzzle
  class Switch < SpriteEntity
    getter? on : Bool
    getter? switching : Bool

    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE

    FPS = 12

    def initialize(x, y)
      super("switch", x, y)

      @frame_t = 0_f32
      @on = true
      @switching = false
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

    def frame
      (@frame_t * FPS).to_i
    end

    def frame=(frame)
      @frame = (frame * FPS).to_i
    end

    def switch
      @switching = true
    end

    def off?
      !on?
    end
  end
end
