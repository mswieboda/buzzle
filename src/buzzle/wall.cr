module Buzzle
  class Wall < SpriteEntity
    @frame : Int32

    def initialize(x, y, z = 0, design = 0)
      super(
        name: "wall",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @frame = design
    end

    def draw(screen_x, screen_y)
      draw(
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
