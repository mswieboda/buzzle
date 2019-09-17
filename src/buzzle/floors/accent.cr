module Buzzle::Floors
  class Accent < SpriteEntity
    enum Design
      Floor
      Grass

      def variations
        case self
        when .floor?
          32
        when .grass?
          32
        else
          0
        end
      end
    end

    def initialize(x, y, z = 0, direction = Direction::Down, @design = Design::Floor, @variation = -1)
      super(
        name: "accents",
        x: x,
        y: y,
        z: z,
        direction: direction
      )

      @width = sprite.width
      @height = sprite.height

      @variation = rand(@design.variations) if @variation < 0
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
        frame: @variation,
        row: @design.to_i
      )
    end
  end
end
