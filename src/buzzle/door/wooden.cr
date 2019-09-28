module Buzzle::Door
  class Wooden < Base
    def initialize(x, y, z = 0, direction = Direction::Down, open = false, darkness = true)
      super(
        x: x,
        y: y,
        z: z,
        direction: direction,
        design: Design::Wooden,
        open: open,
        darkness: darkness
      )
    end

    def actionable?
      true
    end

    def action(_entity : Entity)
      toggle
    end
  end
end
