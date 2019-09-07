module Buzzle
  class Item < SpriteEntity
    property x
    property y
    property z

    def initialize(x = 0, y = 0, z = 0, name = "key")
      super(
        name: name,
        x: x,
        y: y,
        z: z
      )
    end

    def layer
      3
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
