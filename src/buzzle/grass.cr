module Buzzle::Floors
  class Grass < Floor
    TINT = LibRay::GREEN

    def initialize(x, y, z = 0)
      super(
        x: x,
        y: y,
        z: z
      )

      @accent.try { |a| a.tint = TINT }
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: z,
        tint: TINT
      )
    end
  end
end
