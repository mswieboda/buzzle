module Buzzle::Rooms
  class House < Room
    def initialize(@player, entities = [] of Entity, @x = 0, @y = 0, @width = Game::SCREEN_WIDTH / 4, @height = Game::SCREEN_HEIGHT / 8)
      @entities = [] of Entity
      @entities += entities
      @entities << @player
    end
  end
end
