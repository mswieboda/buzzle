require "./wall"

module Buzzle
  class Edge < Wall
    enum Corner
      None
      LeftUp
      LeftDown
      RightUp
      RightDown
    end

    def initialize(x, y, z = 0, name = "floor", direction = Direction::Down, @corner = Corner::None)
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        direction: direction
      )
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: @corner.to_i,
        row: 1 + direction.to_i,
      )
    end

    def directional_collision?(obj : Obj, other_direction : Direction)
      collision?(obj)
    end
  end
end
