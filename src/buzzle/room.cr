module Buzzle
  class Room
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    GRID_SIZE = Game::GRID_SIZE

    def initialize(@x, @y, @width, @height)
      @player = Player.new(3, 3)
      @door = Door.new(3, 0)

      @entities = [] of Entity
      @entities << @door
      @entities << Block.new(5, 3)
      @entities << Block.new(7, 5)
      @entities << @player
    end

    def update(frame_time)
      @player.update(frame_time, @entities)

      @door.toggle_lock! if Keys.pressed?(LibRay::KEY_SPACE)

      @entities.each(&.update(frame_time))

      # sort entities by y
      @entities.sort! { |e1, e2| e1.y <=> e2.y }
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
