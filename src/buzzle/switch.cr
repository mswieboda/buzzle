module Buzzle
  class Switch < SpriteEntity
    getter? on : Bool
    getter? switching : Bool

    FPS = 12

    @sound_done : Sound
    @sound_start : Sound

    def initialize(x, y, z = 0, sprite = "switch", @on = false, width = Game::GRID_SIZE, height = Game::GRID_SIZE, direction = Direction::Down, hidden = false)
      super(
        sprite: sprite,
        x: x,
        y: y,
        z: z,
        width: width,
        height: height,
        direction: direction,
        hidden: hidden
      )

      @frame_t = 0_f32
      @switching = false
      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: (-width / 2).to_i,
        origin_y: (-height / 2).to_i,
        width: width * 2,
        height: height * 2
      )
      @sound_start = Sound.get("switch start")
      @sound_done = Sound.get("switch done")

      self.frame = @sprite.frames - 1 if on?
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        center_y: false,
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
        elsif on? && frame >= 0
          @frame_t -= frame_time

          if frame <= 0
            @switching = false
            off
          end
        end
      end
    end

    def on(sound = true)
      return if on?

      play_sound_done if sound
      self.frame = @sprite.frames - 1
      @on = true
    end

    def off(sound = true)
      return if off?

      play_sound_done if sound
      @frame_t = 0_f32
      @on = false
    end

    def flip(sound = true)
      play_sound_done if sound
      @on = !@on

      @frame_t = 0_f32
      self.frame = @sprite.frames - 1 if on?
    end

    def play_sound_done
      @sound_done.play
    end

    def play_sound_start
      @sound_start.play
    end

    def actionable?
      true
    end

    def action(_entity : Entity)
      switch
    end

    def frame
      (@frame_t * FPS).round.to_i
    end

    def frame=(frame)
      @frame_t = frame.to_f32 / FPS
    end

    def switch(instant = false, sound = !instant)
      if instant
        flip(sound)
      else
        play_sound_start if sound
        @switching = true
      end
    end

    def off?
      !on?
    end
  end
end
