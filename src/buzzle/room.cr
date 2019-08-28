module Buzzle
  class Room
    getter player : Player
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    GRID_SIZE = Game::GRID_SIZE

    def initialize(@player, @entities = [] of Entity, @x = 0, @y = 0, @width = 0, @height = 0)
    end

    def update(frame_time)
      @entities.each(&.update(frame_time, @entities))

      # sort entities by y
      @entities.sort! { |e1, e2| e1.y <=> e2.y }

      @entities.reject!(&.removed?)
    end

    def draw
      draw_room_border if Game::DEBUG
      draw_floor_grid if Game::DEBUG

      @entities.each(&.draw)
    end

    def draw_room_border
      LibRay.draw_rectangle_lines(
        pos_x: 0,
        pos_y: 0,
        width: @width,
        height: @height,
        color: LibRay::GRAY
      )
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
