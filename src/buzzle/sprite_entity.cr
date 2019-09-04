module Buzzle
  class SpriteEntity < Entity
    getter sprite : Sprite
    property source_width : Int32 | Nil
    property source_height : Int32 | Nil

    def initialize(name, x, y, z = 0, width = nil, height = nil, direction = Direction::Down, hidden = false)
      @sprite = Sprite.get(name)

      super(
        x: x,
        y: y,
        z: z,
        width: width || @sprite.width,
        height: height || @sprite.height,
        direction: direction,
        hidden: hidden
      )

      @source_width = nil
      @source_height = nil
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
      draw_partial(
        screen_x: screen_x,
        screen_y: screen_y,
        x: x + (Game::GRID_SIZE - sprite.width) / (center_x ? 2 : 1),
        y: y + (Game::GRID_SIZE - sprite.height) / (center_y ? 2 : 1),
        source_width: source_width || sprite.width,
        source_height: source_height || sprite.height,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      ) unless hidden?

      @trigger.draw(screen_x, screen_y) if Game::DEBUG
    end

    def draw_partial(screen_x, screen_y, x = x, y = y, source_width = width, source_height = height, frame = 0, row = 0, rotation = 0, tint = LibRay::WHITE)
      sprite.draw_partial(
        x: x + screen_x,
        y: y + screen_y,
        source_width: source_width,
        source_height: source_height,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      ) unless hidden?

      @trigger.draw(screen_x, screen_y) if Game::DEBUG
    end
  end
end
