require "./switch"

module Buzzle
  class Door < Switch
    getter direction : Direction

    def initialize(x, y, z = 0, closed = true, @direction = Direction::Down)
      super(
        name: "door",
        x: x,
        y: y,
        z: z,
        on: !closed,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @exiting = false
      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: 0,
        origin_y: 0,
        width: Game::GRID_SIZE
      )
    end

    def layer
      1
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

    def play_sound
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
