module Buzzle
  class Floor < SpriteEntity
    def initialize(x, y, z = 0, name = "floor")
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )
    end

    def layer
      0
    end

    def collidable?
      false
    end
  end
end
