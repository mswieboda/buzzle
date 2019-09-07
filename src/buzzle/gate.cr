module Buzzle
  class Gate < Door
    def initialize(x, y, z = 0, open = false)
      super(
        x: x,
        y: y,
        z: z,
        open: open,
        design: Door::Type::Gate
      )

      @sound_start = Sound.get("gate")
    end

    def actionable?
      false
    end

    def action(_entity : Entity)
    end
  end
end
