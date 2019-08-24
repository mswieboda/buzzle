module Buzzle
  class Block < SpriteEntity
    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE

    DRAW_SIZE_PADDING = 4

    def initialize(x, y)
      super("block", x, y)
    end

    def draw
      draw(tint: LibRay::BLUE)
    end
  end
end
