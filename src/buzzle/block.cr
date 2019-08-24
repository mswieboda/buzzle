module Buzzle
  class Block
    getter x : Int32
    getter y : Int32
    getter sprite : Sprite

    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE

    DRAW_SIZE_PADDING = 4

    def initialize(@x, @y)
      @sprite = Sprite.get("block")
    end

    def update(frame_time)
    end

    def draw
      sprite.draw(
        x: x * WIDTH + WIDTH / 2,
        y: y * HEIGHT + HEIGHT / 2,
        tint: LibRay::BLUE
      )
    end
  end
end
