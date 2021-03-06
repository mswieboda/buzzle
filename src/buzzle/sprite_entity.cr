require "./entity"

module Buzzle
  abstract class SpriteEntity < Entity
    getter sprite : Sprite
    property source_width : Int32 | Nil
    property source_height : Int32 | Nil

    def initialize(sprite, x : Int32, y : Int32, z : Int32 = 0, width = nil, height = nil, direction = Direction::Down, hidden = false)
      @sprite = Sprite.get(sprite)

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

    def draw(screen_x, screen_y, x = x, y = y, center_x = true, center_y = true, frame = 0, row = 0, rotation = 0, tint = Color::White)
      draw_partial(
        screen_x: screen_x,
        screen_y: screen_y,
        x: x + (center_x ? (Game::GRID_SIZE - sprite.width) / 2 : 0),
        y: y + (center_y ? (Game::GRID_SIZE - sprite.height) / 2 : 0),
        source_width: source_width || sprite.width,
        source_height: source_height || sprite.height,
        frame: frame,
        row: row,
        rotation: rotation,
        tint: tint
      ) unless hidden?

      super(
        screen_x: screen_x,
        screen_y: screen_y
      )
    end

    def draw_partial(screen_x, screen_y, x = x, y = y, source_width = width, source_height = height, frame = 0, row = 0, rotation = 0, tint = Color::White)
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
    end
  end
end
