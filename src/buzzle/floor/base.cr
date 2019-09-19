module Buzzle::Floor
  class Base < SpriteEntity
    @accent : Accent | Nil

    def initialize(x, y, z = 0, name = "floor", direction = Direction::Down, width = Game::GRID_SIZE, height = Game::GRID_SIZE, hidden = false)
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        direction: direction,
        width: width,
        height: height,
        hidden: hidden
      )

      @accent = nil

      if rand > 0.85
        @accent = Accent.new(
          x: x,
          y: y,
          z: z,
          direction: direction
        )

        @accent.try(&.randomize_origin)
      end
    end

    def traversable?
      true
    end

    def entities
      (super + [@accent]).compact
    end

    def layer
      0
    end

    def collidable?
      false
    end

    def block_slide?
      false
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: z
      )
    end
  end
end
