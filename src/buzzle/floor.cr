module Buzzle
  class Floor < SpriteEntity
    def initialize(x, y, z = 0, name = "floor", direction = Direction::Down, width = Game::GRID_SIZE, height = Game::GRID_SIZE)
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        width: width,
        height: height,
        direction: direction
      )
    end

    def layer
      0
    end

    def collidable?
      false
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: z
      )
    end
  end
end
