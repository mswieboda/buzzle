require "./wall"

module Buzzle
  class Pillar < Wall
    def initialize(x, y, z = 0, design = 0, direction = Direction::Down, hidden = false)
      super(
        x: x,
        y: y,
        z: z,
        direction: direction,
        hidden: hidden
      )
    end

    def layer
      3
    end

    def draw(screen_x, screen_y)
      draw(
        x: x,
        y: y,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: direction.down? ? 0 : 1,
        row: 5
      )
    end

    def directional_collision?(obj : Obj, _other_direction : Direction)
      collision?(obj)
    end
  end
end
