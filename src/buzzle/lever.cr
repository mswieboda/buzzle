module Buzzle
  class Lever < Switch
    def initialize(x, y, z = 0, on = false)
      super(
        name: "switch",
        x: x,
        y: y,
        z: z,
        on: on
      )
    end

    def initial_visibility
      if on?
        @visibility = Visibility::Shadow
      else
        @visibility = Visibility::Hidden
      end
    end

    def liftable?
      true
    end
  end
end
