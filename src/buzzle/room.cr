module Buzzle
  class Room
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    GRID_SIZE = 64

    def initialize(@x, @y, @width, @height)
      @door = Door.new(64, 0)
      @player = Player.new(64, 64)
    end

    def update(frame_time)
      @door.update(frame_time)

      @door.toggle_lock! if Keys.pressed?(LibRay::KEY_SPACE)

      @player.update(frame_time)
    end

    def draw
      draw_room_border
      draw_floor_grid

      @player.draw
      @door.draw
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
