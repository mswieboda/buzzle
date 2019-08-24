module Buzzle
  class Door
    getter x : Int32
    getter y : Int32
    getter? locked

    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE / 4

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
          pos_x: x * WIDTH,
          pos_y: y * HEIGHT,
          width: WIDTH,
          height: HEIGHT,
          color: LibRay::BROWN
        )
      else
        LibRay.draw_rectangle(
          pos_x: x * WIDTH,
          pos_y: y * HEIGHT,
          width: WIDTH / 8,
          height: HEIGHT,
          color: LibRay::BROWN
        )

        LibRay.draw_rectangle(
          pos_x: x * WIDTH + WIDTH - WIDTH / 8,
          pos_y: y * HEIGHT,
          width: WIDTH / 8,
          height: HEIGHT,
          color: LibRay::BROWN
        )
      end
    end
  end
end
