module Buzzle
  class Player
    getter x : Int32
    getter y : Int32

    WIDTH  = 64
    HEIGHT = 64

    DRAW_SIZE_PADDING = 12

    def initialize(@x, @y, @direction = Direction::Up)
    end

    def update(frame_time)
      if Keys.pressed?([LibRay::KEY_W, LibRay::KEY_UP])
        @y -= WIDTH
        @direction = Direction::Up
      end

      if Keys.pressed?([LibRay::KEY_A, LibRay::KEY_LEFT])
        @x -= WIDTH
        @direction = Direction::Left
      end

      if Keys.pressed?([LibRay::KEY_S, LibRay::KEY_DOWN])
        @y += WIDTH
        @direction = Direction::Down
      end

      if Keys.pressed?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        @x += WIDTH
        @direction = Direction::Right
      end
    end

    def draw
      LibRay.draw_rectangle_v(
        position: LibRay::Vector2.new(
          x: x + DRAW_SIZE_PADDING,
          y: y + DRAW_SIZE_PADDING
        ),
        size: LibRay::Vector2.new(
          x: WIDTH - DRAW_SIZE_PADDING * 2,
          y: HEIGHT - DRAW_SIZE_PADDING * 2,
        ),
        color: LibRay::MAGENTA
      )

      # eyes, for direction
      LibRay.draw_rectangle_v(
        position: LibRay::Vector2.new(
          x: x + WIDTH / 2 - DRAW_SIZE_PADDING / 1.5,
          y: y + DRAW_SIZE_PADDING * 1.5
        ),
        size: LibRay::Vector2.new(
          x: DRAW_SIZE_PADDING / 2,
          y: DRAW_SIZE_PADDING / 2,
        ),
        color: LibRay::BLACK
      )

      LibRay.draw_rectangle_v(
        position: LibRay::Vector2.new(
          x: x + WIDTH / 2 + DRAW_SIZE_PADDING / 1.5,
          y: y + DRAW_SIZE_PADDING * 1.5
        ),
        size: LibRay::Vector2.new(
          x: DRAW_SIZE_PADDING / 2,
          y: DRAW_SIZE_PADDING / 2,
        ),
        color: LibRay::BLACK
      )
    end
  end
end
