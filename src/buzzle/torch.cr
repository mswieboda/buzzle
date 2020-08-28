module Buzzle
  class Torch < Switch
    FPS = 3

    def initialize(x, y, z = 0, on = false)
      super(
        sprite: "torch",
        x: x,
        y: y,
        z: z,
        on: on
      )
    end

    def action(_entity : Entity)
      switch(instant: true, sound: false)
    end

    def light_source?
      on?
    end

    def light_radius
      2
    end

    def light_shadow_extension
      2
    end

    def update(frame_time, entities : Array(Entity))
      # TODO: call super for switching animation
      @trigger.update(self)

      if !switching? && on?
        @frame_t += frame_time

        @frame_t = 0 if frame >= sprite.frames
      end
    end

    def frame
      return 1 if off?
      (@frame_t * FPS).to_i
    end

    def row
      off? ? 0 : 1
    end

    def draw(screen_x, screen_y)
      # bottom
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        row: 0,
        frame: 0
      )

      # top
      draw(
        y: y - height,
        screen_x: screen_x,
        screen_y: screen_y,
        row: row,
        frame: frame
      )
    end
  end
end
