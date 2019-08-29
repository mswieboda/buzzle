module Buzzle
  class WallLadder < Ladder
    def initialize(x, y, z = 0)
      super(
        x: x,
        y: y,
        z: z
      )

      @wall = Wall.new(
        x: x,
        y: y,
        z: z
      )
    end

    def draw(screen_x, screen_y)
      @wall.draw(screen_x, screen_y)
      super
    end
  end
end
