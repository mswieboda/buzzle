module Buzzle
  class Door
    getter x : Int32
    getter y : Int32
    getter? locked

    WIDTH  = 64
    HEIGHT = 16

    def initialize(@x, @y, @locked = true)
    end

    def update(frame_time)
    end

    def toggle_lock!
      @locked = !@locked
    end

    def unlock!
      @locked = false
    end

    def lock!
      @locked = true
    end

    def draw
      if locked?
        LibRay.draw_rectangle(
          pos_x: x,
          pos_y: y,
          width: WIDTH,
          height: HEIGHT,
          color: LibRay::BROWN
        )
      else
        LibRay.draw_rectangle(
          pos_x: x,
          pos_y: y,
          width: WIDTH / 8,
          height: HEIGHT,
          color: LibRay::BROWN
        )

        LibRay.draw_rectangle(
          pos_x: x + WIDTH - WIDTH / 8,
          pos_y: y,
          width: WIDTH / 8,
          height: HEIGHT,
          color: LibRay::BROWN
        )
      end
    end
  end
end
