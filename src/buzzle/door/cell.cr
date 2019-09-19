require "./locked"

module Buzzle::Door
  class Cell < Locked
    def initialize(x, y, z = 0, direction = Direction::Down, open = false, locked = true)
      super(
        x: x,
        y: y,
        z: z,
        direction: direction,
        design: Design::Cell,
        open: open,
        locked: locked
      )

      @wall = Wall.new(
        # TODO: fix this for directions other than Down
        x: x,
        y: y + 1,
        direction: direction.opposite,
        hidden: true
      )
    end

    def entities
      super + [@wall]
    end
  end
end
