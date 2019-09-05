module Buzzle
  class Floor < SpriteEntity
    @accent : Floors::Accent | Nil

    def initialize(x, y, z = 0, name = "floor", direction = Direction::Down, width = Game::GRID_SIZE, height = Game::GRID_SIZE)
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        direction: direction,
        width: width,
        height: height
      )

      @accent = nil

      if rand > 0.85
        @accent = Floors::Accent.new(
          x: x,
          y: y,
          z: z,
          direction: direction,
          width: width,
          height: height
        )

        @accent.try(&.randomize_origin)
      end
    end

    def entities
      if @accent
        [self, @accent.as(Floors::Accent)]
      else
        super
      end
    end

    def layer
      0
    end

    def collidable?
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
