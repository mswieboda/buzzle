module Buzzle::Rooms
  class Playground < Room
    def initialize(@player, entities = [] of Entity, @x = 0, @y = 0, @width = Game::SCREEN_WIDTH, @height = Game::SCREEN_HEIGHT)
      @entities = [] of Entity
      @entities += entities
      @entities << @player
      @entities << Block.new(5 * Game::GRID_SIZE, 3 * Game::GRID_SIZE)
      @entities << Block.new(7 * Game::GRID_SIZE, 5 * Game::GRID_SIZE)
    end
  end
end
