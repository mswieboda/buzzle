module Buzzle
  class Wall < SpriteEntity
    @frame : Int32

    def initialize(x, y, z = 0, design = 0)
      super(
        name: "wall",
        x: x,
        y: y - 1,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @frame = design
    end

    def layer
      1
    end

    def draw(screen_x, screen_y)
      draw(
        y: y + height,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: @frame
      )
    end

    def collidable?
      true
    end
  end
end
