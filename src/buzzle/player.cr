module Buzzle
  class Player
    getter x : Int32
    getter y : Int32

    WIDTH  = 64
    HEIGHT = 64

    DRAW_SIZE_PADDING = 12

    def initialize(@x, @y)
    end

    def update(frame_time)
      @y -= WIDTH if Keys.pressed?([LibRay::KEY_W, LibRay::KEY_UP])
      @x -= WIDTH if Keys.pressed?([LibRay::KEY_A, LibRay::KEY_LEFT])
      @y += WIDTH if Keys.pressed?([LibRay::KEY_S, LibRay::KEY_DOWN])
      @x += WIDTH if Keys.pressed?([LibRay::KEY_D, LibRay::KEY_RIGHT])
    end

    def draw
      LibRay.draw_rectangle(
        pos_x: x + DRAW_SIZE_PADDING,
        pos_y: y + DRAW_SIZE_PADDING,
        width: WIDTH - DRAW_SIZE_PADDING * 2,
        height: HEIGHT - DRAW_SIZE_PADDING * 2,
        color: LibRay::MAGENTA
      )
    end
  end
end
