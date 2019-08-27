module Buzzle
  class SpriteEntity < Entity
    getter sprite : Sprite

    def initialize(asset_file, x, y, width = 1, height = 1)
      @sprite = Sprite.get(asset_file)
      super(x, y, width, height)
    end

    def draw(x = x, y = y, frame = 1, row = 1, rotation = 0, tint = LibRay::WHITE)
      sprite.draw(
        x: x * width * Game::GRID_SIZE + width * Game::GRID_SIZE / 2,
        y: y * height * Game::GRID_SIZE + height * Game::GRID_SIZE / 2,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      )
    end
  end
end
