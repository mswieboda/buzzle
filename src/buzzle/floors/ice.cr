module Buzzle::Floors
  class Ice < Floor
    def initialize(x, y, z = 0)
      super(
        x: x,
        y: y,
        z: z
      )

      @accent = nil
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 4
      )
    end
  end
end
