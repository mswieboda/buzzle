require "./locked"

module Buzzle::Door
  class Cell < Locked
    def initialize(x, y, z = 0, direction = Direction::Down, open = false, locked = true)
      super(
        x: x,
        y: y,
        z: z,
        direction: direction,
        design: Door::Type::Cell,
        open: open,
        locked: locked
      )
    end
  end
end
