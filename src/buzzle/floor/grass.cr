module Buzzle::Floor
  class Grass < Base
    def initialize(x, y, z = 0)
      super(
        x: x,
        y: y,
        z: z
      )

      @accent = nil

      if rand > 0.6
        @accent = Accent.new(
          x: x,
          y: y,
          z: z,
          direction: direction,
          design: Accent::Design::Grass
        )

        @accent.try(&.randomize_origin)
      end
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 3
      )
    end
  end
end
