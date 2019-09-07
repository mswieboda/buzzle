module Buzzle
  class Key < Item
    def initialize(x = 0, y = 0, z = 0)
      super(
        name: "key",
        x: x,
        y: y,
        z: z
      )
    end

    def collidable?
      false
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        center_x: true,
        center_y: false
      )
    end
  end
end
