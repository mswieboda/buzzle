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

    def move(entities : Array(Entity), direction : Direction, times = 1)
      dx = dy = 0

      case direction
      when Direction::Up
        dy -= times
      when Direction::Left
        dx -= times
      when Direction::Down
        dy += times
      when Direction::Right
        dx += times
      end

      @x += dx
      @y += dy

      if collisions?(entities)
        @x -= dx
        @y -= dy
      end
    end
  end
end
