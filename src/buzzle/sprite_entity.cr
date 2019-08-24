module Buzzle
  class SpriteEntity < Entity
    getter sprite : Sprite

    def initialize(asset_file, x, y, width = nil, height = nil)
      @sprite = Sprite.get(asset_file)
      width ||= sprite.width
      height ||= sprite.height
      super(x, y, width, height)
    end

    def draw(frame = 1, row = 1, rotation = 0, tint = LibRay::WHITE)
      sprite.draw(
        x: x * width + width / 2,
        y: y * height + height / 2,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      )
    end
  end
end
