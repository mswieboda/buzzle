module Buzzle
  class SpriteEntity < Entity
    getter sprite : Sprite

    def initialize(name, x, y, z = 0, width = nil, height = nil)
      @sprite = Sprite.get(name)

      super(
        x: x,
        y: y,
        z: z,
        width: width || @sprite.width,
        height: height || sprite.height
      )
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        x: x,
        y: y
      )
    end

    def draw(screen_x, screen_y, x = x, y = y, frame = 0, row = 0, rotation = 0, tint = LibRay::WHITE)
      sprite.draw(
        x: x + screen_x + width / 2 + (Game::GRID_SIZE - width) / 2,
        y: y + screen_y + height / 2 + (Game::GRID_SIZE - height) / 2,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      )

      @trigger.draw(screen_x, screen_y) if Game::DEBUG
    end
  end
end
