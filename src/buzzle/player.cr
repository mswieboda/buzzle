module Buzzle
  class Player
    getter x : Int32
    getter y : Int32
    getter sprite : Sprite
    getter direction : Direction

    WIDTH  = 64
    HEIGHT = 64

    DRAW_SIZE_PADDING = 12

    def initialize(@x, @y, @direction = Direction::Up)
      @sprite = Sprite.get("player")
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
      sprite.draw(
        x: x + WIDTH / 2,
        y: y + HEIGHT / 2,
        row: direction.to_i
      )
    end
  end
end
