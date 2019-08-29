module Buzzle
  class Switch < SpriteEntity
    getter? on : Bool
    getter? switching : Bool

    FPS = 12

    @sound : LibRay::Sound

    def initialize(x, y, z = 0, name = "switch", @on = false, width = Game::GRID_SIZE, height = Game::GRID_SIZE)
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        width: width,
        height: height
      )

      @frame_t = 0_f32
      @switching = false
      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: -width / 2,
        origin_y: -height / 2,
        width: width * 2,
        height: height * 2
      )
      @sound = Sound.get("switch")

      self.frame = @sprite.frames - 1 if on?
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end

    def update(frame_time)
      super

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
