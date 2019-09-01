require "./wall"

module Buzzle::Floors
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
      2
    end

    def draw(screen_x, screen_y)
      draw(
        y: y_draw,
        x: x_draw,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: direction.down? ? 0 : 1,
        row: 4
      )
    end
  end
end
