module Buzzle
  class Room
    getter player : Player
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32
    getter? dark

    @torches : Array(Torch)

    GRID_SIZE = Game::GRID_SIZE

    def initialize(@player, @entities = [] of Entity, width = 10, height = 10, @dark = false)
      @entities = entities.flat_map(&.entities)
      @torches = entities.select(&.is_a?(Torch)).map(&.as(Torch))
      @width = width * GRID_SIZE
      @height = height * GRID_SIZE

      @x = Game::SCREEN_WIDTH / 2 - @width / 2
      @y = Game::SCREEN_HEIGHT / 2 - @height / 2
    end

    def update(frame_time)
      @entities.each(&.initial_visibility) if dark?

      @entities.each(&.update(frame_time, @entities))

      @entities.reject!(&.removed?)

      @entities.sort! { |e1, e2| e1.draw_sort(e2) }
    end

    def draw
      draw_floor_grid if Game::DEBUG

      @entities.each(&.draw(x, y))

      draw_room_border
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

    def draw_room_border
      LibRay.draw_rectangle(
        pos_x: x - GRID_SIZE,
        pos_y: y - GRID_SIZE,
        width: width + GRID_SIZE * 2,
        height: GRID_SIZE,
        color: LibRay::BLACK
      )

      LibRay.draw_rectangle(
        pos_x: x + width,
        pos_y: y - GRID_SIZE,
        width: GRID_SIZE,
        height: height + GRID_SIZE * 2,
        color: LibRay::BLACK
      )

      LibRay.draw_rectangle(
        pos_x: x - GRID_SIZE,
        pos_y: y + height,
        width: width + GRID_SIZE * 2,
        height: GRID_SIZE,
        color: LibRay::BLACK
      )

      LibRay.draw_rectangle(
        pos_x: x - GRID_SIZE,
        pos_y: y - GRID_SIZE,
        width: GRID_SIZE,
        height: height + GRID_SIZE * 2,
        color: LibRay::BLACK
      )
    end
  end
end
