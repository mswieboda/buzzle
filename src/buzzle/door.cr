module Buzzle
  class Door < SpriteEntity
    getter? closed

    def initialize(x, y, @closed = true)
      super("door", x, y, Game::GRID_SIZE, Game::GRID_SIZE)
    end

    def toggle
      @closed = !@closed
    end

    def open
      @closed = false
    end

    def close
      @closed = true
    end

    def collidable?
      closed?
    end

    def frame
      closed? ? 0 : 3
    end

    def draw
      draw(frame: frame)
    end
  end
end
