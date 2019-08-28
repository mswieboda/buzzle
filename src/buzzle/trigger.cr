module Buzzle
  class Trigger < Entity
    getter? hit

    def initialize(x, y, width = 1, height = 1)
      super(x, y, width, height)

      @hit = false
    end
  end
end
