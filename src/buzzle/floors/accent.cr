module Buzzle::Floors
  class Accent < SpriteEntity
    def initialize(x, y, z = 0, direction = Direction::Down, @design = -1)
      super(
        name: "accents",
        x: x,
        y: y,
        z: z,
        direction: direction
      )

      @width = sprite.width
      @height = sprite.height

      @design = rand(sprite.frames) - 1 if @design < 0
    end

    def layer
      1
    end

    def collidable?
      false
    end

    def randomize_origin
      @x += rand(Game::GRID_SIZE - sprite.width)
      @y += rand(Game::GRID_SIZE - sprite.height)
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
