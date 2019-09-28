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
  end
end
