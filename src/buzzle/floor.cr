module Buzzle
  class Floor < SpriteEntity
    def initialize(x, y, z = 0)
      super(
        name: "block",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )
    end

    def collidable?
      false
    end
  end
end
