module Buzzle
  class Door < Entity
    getter? locked

    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE / 4

    def initialize(x, y, @locked = true)
      super(x, y, Game::GRID_SIZE, Game::GRID_SIZE)
    end

    def toggle_lock
      @locked = !@locked
    end

    def unlock
      @locked = false
    end

    def lock
      @locked = true
    end

    def collidable?
      locked?
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
