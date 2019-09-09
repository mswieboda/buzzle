module Buzzle
  class Torch < Switch
    FPS = 3

    def initialize(x, y, z = 0, @bottom = false, on = false)
      super(
        name: "torch",
        x: x,
        y: y,
        z: z,
        on: on
      )
    end

    def layer
      3
    end

    def action(_entity : Entity)
      switch(instant: true, sound: false)
    end

    def update(frame_time)
      @trigger.update(self)

      @frame_t += frame_time

      @frame_t = 0 if frame >= sprite.frames
    end

    def frame
      return 1 if off?
      2 + (@frame_t * FPS).to_i
    end

    def draw(screen_x, screen_y)
      # bottom
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 0
      )

      # top
      draw(
        y: y - height,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end
  end
end
