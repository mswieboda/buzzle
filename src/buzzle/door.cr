require "./switch"

module Buzzle
  class Door < Switch
    def initialize(x, y, closed = true)
      super(x, y, "door", !closed, Game::GRID_SIZE, Game::GRID_SIZE)
    end

    def toggle
      switch
    end

    def closed?
      off?
    end

    def open?
      on?
    end

    def open
      toggle if closed?
    end

    def close
      toggle if open?
    end

    def collidable?
      closed?
    end
  end
end
