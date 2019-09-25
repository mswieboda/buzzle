module Buzzle
  class Visibility < Obj
    delegate visible?, to: @state
    delegate shadow?, to: @state
    delegate dark?, to: @state

    enum State
      Visible
      Shadow
      Dark
    end

    def initialize(x, y, @state = State::Shadow)
      super(
        x: x,
        y: y
      )
    end

    def width
      Game::GRID_SIZE
    end

    def height
      Game::GRID_SIZE
    end

    def visible!
      @state = State::Visible
    end

    def shadow!
      @state = State::Shadow
    end

    def dark!
      @state = State::Dark
    end

    def draw(screen_x, screen_y)
      return if visible?

      tint = LibRay::Color.new(r: 0, g: 0, b: 0, a: dark? ? 255 : 150)

      LibRay.draw_rectangle(
        pos_x: x + screen_x,
        pos_y: y + screen_y,
        width: width,
        height: height,
        color: tint
      )
    end
  end
end
