module Buzzle::Rooms
  class Entrance < Room
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
          next if y == 3 || (y >= 5 && y <= 7)
          @entities << Floors::Grass.new(x, y)
        end
      end

      # block
      # @entities << Block.new(5, 5)
      @entities << Block.new(5, 7)

      block = Block.new(3, 7)
      @entities << block
      block.move(dx: 0, dy: -1, amount: 2)

      # river
      (0..width - 1).each do |x|
        @entities << Floors::River.new(x, 3)
      end

      # ice
      (0..width - 1).each do |x|
        (5..7).each do |y|
          @entities << Floors::Ice.new(x, y)
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
