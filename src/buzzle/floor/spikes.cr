module Buzzle::Floor
  class Spikes < Base
    getter? up
    getter? animating

    FPS = 12

    DELAY_TIMER = 3

    def initialize(x, y, z = 0, @up = false)
      super(
        sprite: "spike",
        x: x,
        y: y,
        z: z
      )

      @accent = nil
      @animating = false
      @frame_t = 0_f32

      @timer = Timer.new(DELAY_TIMER)
    end

    def layer
      1
    end

    def down?
      !up?
    end

    def collidable?
      up?
    end

    def update(frame_time)
      if animating?
        if down?
          @frame_t += frame_time

          if frame >= sprite.frames - 1
            @frame_t = (sprite.frames - frame_time) / FPS
            @up = true
            @animating = false
          end
        else
          @frame_t -= frame_time

          if frame <= 0
            @frame_t = 0_f32
            @up = false
            @animating = false
          end
        end
      else
        if @timer.done?
          @timer.reset
          @animating = true
        else
          @timer.increase(frame_time)
        end
      end
    end

    def frame
      (@frame_t * FPS).to_i
    end

    def draw(screen_x, screen_y)
      4.times do |dx|
        4.times do |dy|
          draw(
            screen_x: screen_x,
            screen_y: screen_y,
            center_x: false,
            center_y: false,
            x: x + sprite.width * dx,
            y: y + sprite.height * dy,
            frame: frame
          )
        end
      end
    end
  end
end
