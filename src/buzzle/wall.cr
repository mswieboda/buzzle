module Buzzle
  class Wall < SpriteEntity
    getter? enabled

    @frame : Int32

    def initialize(x, y, z = 0, name = "wall", design = 0, direction = Direction::Down, hidden = false, @railing = false)
      super(
        name: name,
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE,
        direction: direction,
        hidden: hidden
      )

      @enabled = true
      @frame = design
    end

    def enable
      @enabled = true
    end

    def disable
      @enabled = false
    end

    def disabled?
      !enabled?
    end

    def layer
      2
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
        y: y_draw,
        x: x_draw,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: @frame,
        row: direction.to_i
      )

      if direction.down? && @railing
        draw(
          y: y_draw,
          x: x_draw,
          screen_x: screen_x,
          screen_y: screen_y,
          frame: @frame,
          row: 4
        )
      end
    end

    def draw_partial(screen_x, screen_y, source_width = width, source_height = height)
      draw_partial(
        y: y_draw,
        x: x_draw,
        screen_x: screen_x,
        screen_y: screen_y,
        source_width: source_width,
        source_height: source_height,
        frame: @frame,
        row: direction.to_i
      )

      if direction.down? && @railing
        draw(
          y: y_draw,
          x: x_draw,
          screen_x: screen_x,
          screen_y: screen_y,
          frame: @frame,
          row: 4
        )
      end
    end

    def collidable?
      enabled?
    end

    def directional_collision?(obj : Obj, other_direction : Direction)
      collision?(obj) && direction.opposite == other_direction
    end
  end
end
