module Buzzle
  class SpriteEntity < Entity
    getter sprite : Sprite

    def initialize(asset_file, x, y, width = nil, height = nil)
      @sprite = Sprite.get(asset_file)
      super(x, y, width || @sprite.width, height || sprite.height)
    end

    def draw(x = x, y = y, frame = 0, row = 0, rotation = 0, tint = LibRay::WHITE)
      sprite.draw(
        x: x + width / 2 + (Game::GRID_SIZE - width) / 2,
        y: y + height / 2 + (Game::GRID_SIZE - height) / 2,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      )
    end
  end
end
