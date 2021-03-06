module Buzzle::Door
  class Base < Switch
    getter? exiting

    enum Design
      Wooden
      Locked
      Gate
      Cell
    end

    def initialize(x, y, z = 0, direction = Direction::Down, @design = Design::Wooden, open = false, darkness = true)
      super(
        sprite: "door",
        x: x,
        y: y,
        z: z,
        on: open,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE,
        direction: direction
      )

      @exiting = false

      origin_x = 0
      origin_y = 0
      t_width = 1
      t_height = 1

      if direction.up?
        origin_y = height - 1
        t_width = Game::GRID_SIZE
      elsif direction.right?
        origin_x = 0
        t_height = Game::GRID_SIZE
      elsif direction.down?
        origin_y = 0
        t_width = Game::GRID_SIZE
      elsif direction.left?
        origin_x = width - 1
        t_height = Game::GRID_SIZE
      end

      @enter_trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: origin_x,
        origin_y: origin_y,
        width: t_width,
        height: t_height
      )

      origin_x = 0
      origin_y = 0

      if direction.up?
        origin_y = -height / 2
      elsif direction.right?
        origin_x = width / 2
      elsif direction.down?
        origin_y = height / 2
      elsif direction.left?
        origin_x = -width / 2
      end

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: origin_x.to_i,
        origin_y: origin_y.to_i,
        width: width,
        height: height
      )

      @sound_start = Sound.get("gate") if @design == Design::Gate

      @darkness = nil
      @darkness = Darkness.new(x, y, z, layer: 4) if darkness
    end

    def entities
      entities = [] of Entity
      entities << self
      entities << @darkness.as(Darkness) if @darkness
      entities
    end

    def layer
      direction.down? || direction.left? ? 2 : 4
    end

    def traversable?
      true
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
      return unless @design == Design::Gate
      super
    end

    def play_sound_done
    end

    def collidable?
      closed? || active?
    end

    def directional_collision?(obj : Obj, other_direction : Direction)
      collision?(obj) && direction.opposite == other_direction
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

      if direction.up?
        y_draw -= height
      elsif direction.down?
        y_draw += height
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
        row: direction.to_i * Design.values.size + @design.to_i
      )

      @enter_trigger.draw(screen_x, screen_y) if Game::DEBUG
    end
  end
end
