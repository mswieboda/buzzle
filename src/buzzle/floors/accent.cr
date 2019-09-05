module Buzzle::Floors
  class Accent < SpriteEntity
    def initialize(x, y, z = 0, direction = Direction::Down, width = Game::GRID_SIZE, height = Game::GRID_SIZE, @design = -1)
      super(
        name: "accents",
        x: x,
        y: y,
        z: z,
        width: width,
        height: height,
        direction: direction
      )

      @design = rand(sprite.frames) - 1 if @design < 0
    end

    def layer
      1
    end

    def collidable?
      false
    end

    def randomize_origin
      @x += rand(width - sprite.width)
      @y += rand(height - sprite.height)
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        center_x: false,
        center_y: false,
        frame: @design
      )
    end
  end
end
