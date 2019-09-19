module Buzzle::Room
  class Entrance < Base
    def initialize(player, entities = [] of Entity, width = 10, height = 10)
      @entities = [] of Entity
      @entities += entities
      @entities << player

      # outer walls
      ((0..2).to_a + (4..width - 1).to_a).each do |x|
        @entities << Wall.new(x, -1, design: rand > 0.5 ? 0 : rand(6))
      end

      # floors
      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          # skip if river or ice
          next if y == 3 || (x > 0 && x < width - 1 && y >= 4 && y <= 7)
          @entities << Floor::Grass.new(x, y)
        end
      end

      # pit
      @entities << Floor::Pit.new(5, 4)

      # block
      @entities << Block.new(5, 7)

      # river
      (0..width - 1).each do |x|
        @entities << Floor::River.new(x, 3)
      end

      # ice
      (1..width - 2).each do |x|
        (4..7).each do |y|
          next if x == 5 && y == 4
          @entities << Floor::Ice.new(x, y)
        end
      end

      super(
        player: player,
        entities: @entities,
        width: width,
        height: height
      )
    end
  end
end
