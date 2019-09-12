require "./switch"

module Buzzle
  class Door < Switch
    getter? exiting

    enum Type
      Wooden
      WoodenLocked
      Gate
    end

    def initialize(x, y, z = 0, open = false, @design = Type::Wooden, direction = Direction::Down, hidden = false)
      super(
        name: "door",
        x: x,
        y: y,
        z: z,
        on: open,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE,
        direction: direction,
        hidden: hidden
      )

      @exiting = false
      @enter_trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: 0,
        origin_y: 0,
        width: Game::GRID_SIZE
      )

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: 0,
        origin_y: height / 2,
        width: width,
        height: height
      )

      @sound_start = Sound.get("gate") if @design == Type::Gate
    end

    def layer
      direction.down? ? 2 : 4
    end

    def enter_trigger?(entity : Entity)
      !exiting? && open? && @enter_trigger.trigger?(entity)
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
      if enter_trigger?(player) && direction.opposite == player.direction
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

    def x_draw
      x_draw = x

      if direction.right?
        x_draw += width
      elsif direction.left?
        x_draw -= width
      end

      x_draw
    end

    def y_draw
      y_draw = y

      if direction.down?
        y_draw += height
      elsif direction.up?
        y_draw -= height
      end

      y_draw
    end

    def draw(screen_x, screen_y)
      draw(
        x: x_draw,
        y: y_draw,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame,
        row: @design.to_i
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
