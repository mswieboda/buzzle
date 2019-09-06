require "./switch"

module Buzzle
  class Door < Switch
    getter? exiting

    @railing : SpriteEntity | Nil

    enum Type
      Wooden
      Gate
    end

    def initialize(x, y, z = 0, open = false, @design = Type::Wooden)
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

      @sound_start = Sound.get("gate") if @design == Type::Gate
    end

    def layer
      2
    end

    def trigger?(entity : Entity)
      !exiting? && open? && super(entity)
    end

    def toggle(instant = false)
      return if active?

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

    def active?
      switching? || exiting?
    end

    def play_sound_start
      return unless @design == Type::Gate
      super
    end

    def play_sound_done
    end

    def collidable?
      closed? || active?
    end

    def entered?(player : Player)
      if trigger?(player) && direction.opposite == player.direction
        exit
        player.exit_door = self
        true
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
        frame: frame,
        row: @design.to_i
      )
    end

    def actionable?
      true
    end

    def action
      toggle
    end
  end
end
