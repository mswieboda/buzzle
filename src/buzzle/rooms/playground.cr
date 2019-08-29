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
          if x == 5 && y == 8
            @entities << Floors::Pit.new(x, y)
          else
            @entities << Floor.new(x, y)
          end
        end
      end

      @entities << Wall.new(5, 6)
      @entities << Floor.new(5, 6, 1)
      @entities << Wall.new(6, 6)
      @entities << Floor.new(6, 6, 1)
      @entities << WallLadder.new(7, 7)
      @entities << Ladder.new(7, 7, 1, ascend: false)
      @entities << Floor.new(7, 6, 1)
      @entities << Floor.new(8, 6, 1)

      @entities << Wall.new(10, 10, direction: Direction::Right)
      @entities << Wall.new(10, 10, direction: Direction::Up)
      @entities << Wall.new(10, 10, direction: Direction::Down)
      @entities << Wall.new(10, 10, direction: Direction::Left)

      ((0..2).to_a + [4] + (6..width - 1).to_a).each do |x|
        @entities << Wall.new(x, -1, design: rand > 0.5 ? 0 : rand(6))
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
