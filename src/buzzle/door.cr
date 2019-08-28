require "./switch"

module Buzzle
  class Door < Switch
    getter direction : Direction

    def initialize(x, y, closed = true, @direction = Direction::Down)
      super(x, y, "door", !closed, Game::GRID_SIZE, Game::GRID_SIZE)

      @exiting = false
      @trigger = Trigger.new(x, y, 0, 0, Game::GRID_SIZE)
    end

    def trigger?(entity : Entity)
      !@exiting && open? && super(entity)
    end

    def toggle(instant = false)
      switch(instant)
    end

    def closed?
      off?
    end

    def open?
      on?
    end

    def open(instant = false)
      toggle(instant) if closed?
    end

    def close(instant = false)
      toggle(instant) if open?
    end

    def collidable?
      closed?
    end

    def exit
      @exiting = true
    end

    def done_exiting
      @exiting = false
    end
  end
end
