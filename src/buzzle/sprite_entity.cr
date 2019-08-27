module Buzzle
  class SpriteEntity < Entity
    getter sprite : Sprite

    def initialize(asset_file, x, y, width = nil, height = nil)
      @sprite = Sprite.get(asset_file)
      super(x, y, width || @sprite.width, height || sprite.height)
    end

    def draw(x = x, y = y, frame = 1, row = 1, rotation = 0, tint = LibRay::WHITE)
      sprite.draw(
        x: x - width / 2 + Game::GRID_SIZE,
        y: y - height / 2 + Game::GRID_SIZE / 2,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      )
    end
  end
end
