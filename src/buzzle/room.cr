module Buzzle
  class Room
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    def initialize(@x, @y, @width, @height)
      @door = Door.new(32, 0)
    end

    def update(frame_time)
      @door.update(frame_time)

      @door.toggle_lock! if Keys.pressed?(LibRay::KEY_SPACE)
    end

    def draw
      draw_room_border

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
  end
end
