module Buzzle
  class Switch < SpriteEntity
    getter? on : Bool
    getter? switching : Bool

    FPS = 12

    @sound : LibRay::Sound

    def initialize(x, y, asset_name = "switch", @on = false, width = Game::GRID_SIZE, height = Game::GRID_SIZE)
      super(asset_name, x, y, width, height)

      @frame_t = 0_f32
      @switching = false
      @trigger = Trigger.new(x, y, -width / 2, -width / 2, width * 2, height * 2)
      @sound = Sound.get("switch")

      self.frame = @sprite.frames - 1 if on?
    end

    def draw
      draw(frame: frame)
    end

    def update(frame_time)
      if switching?
        if off? && frame <= sprite.frames - 2
          @frame_t += frame_time

          if frame >= sprite.frames - 1
            @switching = false
            on
          end
        elsif on? && frame >= 1
          @frame_t -= frame_time

          if frame <= 0
            @switching = false
            off
          end
        end
      end
    end

    def on(sound = true)
      play_sound if sound
      @on = true
    end

    def off(sound = true)
      play_sound if sound
      @on = false
    end

    def flip(sound = true)
      play_sound if sound
      @on = !@on
    end

    def play_sound
      Sound.play(@sound)
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

    def switch(instant = false)
      if instant
        flip(!instant)

        @frame_t = 0_f32

        self.frame = @sprite.frames - 1 if on?
      else
        @switching = true
      end
    end

    def off?
      !on?
    end
  end
end
