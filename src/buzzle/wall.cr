module Buzzle
  class Wall < SpriteEntity
    @frame : Int32

    def initialize(x, y, z = 0, design = 0, direction = Direction::Down, hidden = false)
      super(
        name: "wall",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE,
        direction: direction,
        hidden: hidden
      )

      @frame = design
    end

    def layer
      1
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
    end

    def collidable?
      true
    end

    def directional_collision?(other_direction : Direction)
      direction.opposite == other_direction
    end
  end
end
