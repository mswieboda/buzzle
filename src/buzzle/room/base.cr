require "../scene/view"

module Buzzle::Room
  class Base
    getter player : Player
    property x : Int32 | Float32
    property y : Int32 | Float32
    getter width : Int32
    getter height : Int32
    getter doors

    GRID_SIZE = Game::GRID_SIZE

    @entities : Array(Entity)
    @doors : Hash(Symbol, Door::Base)
    @quests = {} of String => Hash(String, Bool)

    def initialize(@player, entities = [] of Entity, @doors = {} of Symbol => Door::Base, width = 10, height = 10)
      @width = width * GRID_SIZE
      @height = height * GRID_SIZE

      @x = 0
      @y = 0

      entities += @doors.values.to_a
      @entities = entities.flat_map(&.entities)
    end

    def update(frame_time)
      @entities.each(&.update(frame_time, @entities))

      @entities.reject!(&.removed?)

      @entities.sort! { |e1, e2| e1.draw_sort(e2) }
    end

    def draw(view : Scene::View)
      entities = @entities.select { |e| view.viewable?(e) }
      entities.each(&.draw(view.screen_x, view.screen_y))
    end

    def add_border_walls
      add_top_walls
      add_left_walls
      add_right_walls
    end

    def add_top_walls
      walls = [] of Wall
      width = (@width / Game::GRID_SIZE).to_i
      height = (@height / Game::GRID_SIZE).to_i
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
      width = (@width / Game::GRID_SIZE).to_i
      height = (@height / Game::GRID_SIZE).to_i
      x = -1

      height.times do |y|
        # left side railing
        walls << Wall.new(x, y, direction: Direction::Right) unless door?(x: x, y: y)
      end

      @entities += walls.flat_map(&.entities)
    end

    def add_right_walls
      walls = [] of Wall
      width = (@width / Game::GRID_SIZE).to_i
      height = (@height / Game::GRID_SIZE).to_i
      x = width

      height.times do |y|
        # right side railing
        walls << Wall.new(x, y, direction: Direction::Left) unless door?(x: x, y: y)
      end

      @entities += walls.flat_map(&.entities)
    end

    def add_up_wall(x, y)
      entities = [] of Entity
      entities << Wall.new(x, y, direction: Direction::Up)
      entities << Wall.new(x, y + 1, direction: Direction::Down, hidden: true)
      entities
    end

    def add_right_wall(x, y)
      entities = [] of Entity
      entities << Wall.new(x, y, direction: Direction::Right)
      entities << Wall.new(x + 1, y, direction: Direction::Left, hidden: true)
      entities
    end

    def add_left_wall(x, y, inner = false)
      entities = [] of Entity
      entities << Wall.new(x - 1, y, direction: Direction::Right, hidden: true)
      entities << Wall.new(x, y, direction: Direction::Left)
      entities
    end

    def add_down_wall(x, y)
      entities = [] of Entity
      entities << Wall.new(x, y + 1, direction: Direction::Up)
      entities << Wall.new(x, y, direction: Direction::Down)
      entities
    end

    def door?(x, y)
      doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
    end

    def quest_step?(quest, step)
      return false unless Quest.done?(quest, step)

      if @quests[quest]? && @quests[quest][step]?
        return false
      end

      @quests[quest] ||= {} of String => Bool
      @quests[quest][step] ||= true

      true
    end
  end
end
