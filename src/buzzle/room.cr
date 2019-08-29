module Buzzle
  class Room
    getter player : Player
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    GRID_SIZE = Game::GRID_SIZE

    def initialize(@player, @entities = [] of Entity, width = 10, height = 10)
      @width = width * GRID_SIZE
      @height = height * GRID_SIZE

      @x = Game::SCREEN_WIDTH / 2 - @width / 2
      @y = Game::SCREEN_HEIGHT / 2 - @height / 2
    end

    def update(frame_time)
      @entities.each(&.update(frame_time, @entities))

      @entities.sort! { |e1, e2| e1.draw_sort(e2) }

      @entities.reject!(&.removed?)
    end

    def draw
      draw_floor_grid if Game::DEBUG

      @entities.each(&.draw(x, y))
    end

    def draw_floor_grid
      (width / GRID_SIZE).times do |x|
        (height / GRID_SIZE).times do |y|
          LibRay.draw_rectangle_lines(
            pos_x: @x + x * GRID_SIZE,
            pos_y: @y + y * GRID_SIZE,
            width: GRID_SIZE,
            height: GRID_SIZE,
            color: LibRay::GRAY
          )
        end
      end
    end
  end
end
