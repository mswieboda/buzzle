module Buzzle::Rooms
  class Playground < Room
    def initialize(player, entities = [] of Entity, width = 15, height = 15)
      @entities = [] of Entity
      @entities += entities
      @entities << player
      @entities << Block.new(5, 3)
      @entities << Block.new(7, 5)

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          next if x == 5 && y == 5
          @entities << Floor.new(x, y)
        end
      end

      @entities << Floors::Pit.new(5, 5)
      @entities << Ladder.new(7, 7)

      ((0..2).to_a + [4] + (6..width - 1).to_a).each do |x|
        @entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
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
