module Buzzle
  class Block < SpriteEntity
    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE

    def initialize(x, y)
      super("block", x, y, WIDTH, HEIGHT)

      @moving_x = @moving_y = 0_f32
    end

    def draw
      draw(x: x + @moving_x, y: y + @moving_y, tint: LibRay::BLUE)
    end

    def actionable?
      true
    end

    def move(dx, dy, entities : Array(Entity))
      @x += dx
      @y += dy

      if collision?(entities.select(&.collidable?))
        @x -= dx
        @y -= dy
      end
    end
  end
end
