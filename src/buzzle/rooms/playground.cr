module Buzzle::Rooms
  class Playground < Room
    def initialize(@player, entities = [] of Entity, @x = 0, @y = 0, @width = 0, @height = 0)
      @entities = [] of Entity
      @entities += entities
      @entities << @player
      @entities << Block.new(5 * Game::GRID_SIZE, 3 * Game::GRID_SIZE)
      @entities << Block.new(7 * Game::GRID_SIZE, 5 * Game::GRID_SIZE)
    end
  end
end
