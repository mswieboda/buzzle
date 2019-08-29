module Buzzle
  class Block < SpriteEntity
    def initialize(x, y, z = 1)
      super(
        name: "block",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @moving_x = @moving_y = 0_f32
      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: -width / 2,
        origin_y: -height / 2,
        width: width * 2,
        height: height * 2
      )
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
