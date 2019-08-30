require "./switch"

module Buzzle
  class Door < Switch
    getter direction : Direction

    def initialize(x, y, z = 0, open = false, @direction = Direction::Down)
      super(
        name: "door",
        x: x,
        y: y - 1,
        z: z,
        on: open,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @exiting = false
      @trigger = Trigger.new(
        x: x,
        y: y - 1,
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
      closed? || switching?
    end

    def entered?(player : Player)
      if trigger?(player)
        exit
        player.exit_door = self
        direction.opposite == player.direction
      else
        false
      end
    end

    def exit
      @exiting = true
    end

    def done_exiting
      @exiting = false
    end

    def draw(screen_x, screen_y)
      draw(
        y: y + height,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end

    def directional_collision?(other_direction : Direction)
      if direction.opposite == other_direction
        false
      else
        true
      end
    end
  end
end
