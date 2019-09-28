module Buzzle
  class Darkness < Entity
    def initialize(x, y, z = 0, width = Game::GRID_SIZE, height = Game::GRID_SIZE, @layer = 3)
      super(
        x: x,
        y: y,
        z: z,
        width: width,
        height: height
      )
    end

    def layer
      @layer
    end

    def collidable?
      false
    end

    def draw(screen_x, screen_y)
      tint = LibRay::Color.new(r: 0, g: 0, b: 0, a: Game::DEBUG ? 192 : 255)

      LibRay.draw_rectangle(
        pos_x: x + screen_x,
        pos_y: y + screen_y,
        width: width,
        height: height,
        color: tint
      )
    end
  end
end
