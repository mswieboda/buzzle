module Buzzle
  class Ladder < Floor
    def initialize(x, y, z = 0)
      super(
        name: "ladder",
        x: x,
        y: y,
        z: z
      )
    end

    def layer
      1
    end

    def collidable?
      false
    end
  end
end
