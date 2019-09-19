module Buzzle
  class WallTorch < Switch::Base
    FPS = 12

    def initialize(x, y, z = 0, on = true)
      super(
        name: "torch",
        x: x,
        y: y,
        z: z,
        on: on
      )
    end

    def switch(instant = false, sound = !instant)
      @frame_t = (@sprite.frames - 1).to_f32 / FPS if on?
      super(instant, sound)
    end

    def layer
      2
    end

    def actionable?
      false
    end

    def collidable?
      false
    end

    def light_source?
      on?
    end

    def light_shadow_extension
      1
    end

    def update_visibility(visibility : Visibility)
      radius = light_radius * Game::GRID_SIZE
      size = radius * 2 + Game::GRID_SIZE

      if visibility.collision?(x: @x - radius, y: @y, width: size, height: size / 2)
        visibility.visible!
      end

      if visibility.dark?
        radius = (light_radius + light_shadow_extension) * Game::GRID_SIZE
        size = radius * 2 + Game::GRID_SIZE

        if visibility.collision?(x: @x - radius, y: @y, width: size, height: size / 2)
          visibility.shadow!
        end
      end
    end

    def frame
      return (@frame_t * FPS).to_i if switching?
      off? ? 0 : sprite.frames - 1
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        row: 2,
        frame: frame
      )
    end
  end
end
