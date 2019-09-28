module Buzzle::Room
  class Base
    getter player : Player
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32
    getter doors

    GRID_SIZE = Game::GRID_SIZE

    @entities : Array(Entity)
    @doors : Hash(Symbol, Door::Base)

    def initialize(@player, entities = [] of Entity, @doors = {} of Symbol => Door::Base, width = 10, height = 10)
      @width = width * GRID_SIZE
      @height = height * GRID_SIZE

      @x = Game::SCREEN_WIDTH / 2 - @width / 2
      @y = Game::SCREEN_HEIGHT / 2 - @height / 2

      entities += @doors.values.to_a
      @entities = entities.flat_map(&.entities)
    end

    def update(frame_time)
      @entities.each(&.update(frame_time, @entities))

      @entities.reject!(&.removed?)

      @entities.sort! { |e1, e2| e1.draw_sort(e2) }
    end

    def draw
      @entities.each(&.draw(x, y))
    end

    def add_border_walls
      add_top_walls
      add_left_walls
      add_right_walls
    end

    def add_top_walls
      walls = [] of Wall
      width = @width / Game::GRID_SIZE
      height = @height / Game::GRID_SIZE
      y = -1

      width.times do |x|
        # top railing for design only (goes outside of room)
        walls << Wall.new(x, y + 1, direction: Direction::Up)

        next if door?(x: x, y: y)

        # top wall
        walls << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      @entities += walls.flat_map(&.entities)
    end

    def add_left_walls
      walls = [] of Wall
      width = @width / Game::GRID_SIZE
      height = @height / Game::GRID_SIZE
      x = -1

      height.times do |y|
        # left side railing
        walls << Wall.new(x, y, direction: Direction::Right) unless door?(x: x, y: y)
      end

      @entities += walls.flat_map(&.entities)
    end

    def add_right_walls
      walls = [] of Wall
      width = @width / Game::GRID_SIZE
      height = @height / Game::GRID_SIZE
      x = width

      height.times do |y|
        # right side railing
        walls << Wall.new(x, y, direction: Direction::Left) unless door?(x: x, y: y)
      end

      @entities += walls.flat_map(&.entities)
    end

    def door?(x, y)
      doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
    end
  end
end
