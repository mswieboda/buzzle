module Buzzle::Rooms
  class Playground < Room
    def initialize(@player, entities = [] of Entity, @x = 0, @y = 0, @width = Game::SCREEN_WIDTH, @height = Game::SCREEN_HEIGHT)
      @entities = [] of Entity
      @entities += entities
      @entities << @player
      @entities << Block.new(5, 3)
      @entities << Block.new(7, 5)

      (3..10).each do |x|
        (0..10).each do |y|
          @entities << Floor.new(x, y)
        end
      end
    end
  end
end
