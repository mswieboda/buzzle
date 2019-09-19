module Buzzle
  class Lever < Switch::Base
    def initialize(x, y, z = 0, on = false)
      super(
        name: "switch",
        x: x,
        y: y,
        z: z,
        on: on
      )
    end

    def liftable?
      true
    end

    def light_source?
      on?
    end

    def update_visibility(visibility : Visibility)
      size = Game::GRID_SIZE

      if visibility.collision?(x: @x, y: @y, width: size, height: size)
        visibility.visible!
      end

      if visibility.dark? && visibility.collision?(x: @x, y: @y + size, width: size, height: size)
        visibility.shadow!
      end
    end
  end
end
