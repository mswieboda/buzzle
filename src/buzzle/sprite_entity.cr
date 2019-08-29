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

    def draw(screen_x, screen_y, x = x, y = y, center_x = true, center_y = true, frame = 0, row = 0, rotation = 0, tint = LibRay::WHITE)
      sprite.draw(
        x: x + screen_x + (Game::GRID_SIZE - sprite.width) / (center_x ? 2 : 1),
        y: y + screen_y + (Game::GRID_SIZE - sprite.height) / (center_y ? 2 : 1),
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      )

      @trigger.draw(screen_x, screen_y) if Game::DEBUG
    end
  end
end
