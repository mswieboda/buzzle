module Buzzle::Door
  class Gate < Base
    def initialize(x, y, z = 0, direction = Direction::Down, open = false)
      super(
        x: x,
        y: y,
        z: z,
        direction: direction,
        design: Design::Gate,
        open: open
      )

      @sound_start = Sound.get("gate")
    end

    def actionable?
      false
    end
  end
end
