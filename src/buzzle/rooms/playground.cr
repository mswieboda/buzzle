module Buzzle::Rooms
  class Playground < Room
    def initialize(player, entities = [] of Entity, width = 15, height = 15)
      @entities = [] of Entity
      @entities += entities
      @entities << player
      @entities << Block.new(5, 3)
      @entities << Block.new(3, 5)

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          if x == 5 && y == 8
            @entities << Floors::Pit.new(x, y)
          else
            @entities << Floor.new(x, y)
          end
        end
      end

      @entities << Pillar.new(3, 4, direction: Direction::Up)
      @entities << Pillar.new(3, 3)

      @entities << Wall.new(5, 6)
      @entities << Edge.new(5, 6, 1)
      @entities << Wall.new(5, 6, direction: Direction::Up, hidden: true)
      @entities << Floor.new(5, 5, 1)
      @entities << Floor.new(5, 6, 1)
      @entities << Floor.new(6, 5, 1)
      @entities << Wall.new(6, 6)
      @entities << Edge.new(6, 6, 1)
      @entities << Wall.new(6, 6, direction: Direction::Up, hidden: true)
      @entities << Floor.new(6, 6, 1)
      @entities << WallLadder.new(7, 7)
      @entities << Ladder.new(7, 7, 1, ascend: false)
      @entities << Floor.new(7, 5, 1)
      @entities << Wall.new(7, 6, direction: Direction::Up, hidden: true)
      @entities << Floor.new(7, 6, 1)
      @entities << Floor.new(8, 5, 1)
      @entities << Wall.new(8, 6, direction: Direction::Up, hidden: true)
      @entities << Floor.new(8, 6, 1)
      @entities << Edge.new(9, 6, 1, direction: Direction::Right)
      @entities << Edge.new(9, 5, 1, direction: Direction::Right)
      @entities << Edge.new(8, 6, 1, direction: Direction::Down)
      @entities << Edge.new(8, 4, 1, direction: Direction::Up)
      @entities << Edge.new(7, 4, 1, direction: Direction::Up)
      @entities << Edge.new(6, 4, 1, direction: Direction::Up)
      @entities << Edge.new(5, 4, 1, direction: Direction::Up)
      @entities << Edge.new(4, 5, 1, direction: Direction::Left)
      @entities << Edge.new(4, 6, 1, direction: Direction::Left)

      @entities << Wall.new(10, 10)
      @entities << Wall.new(10, 11, direction: Direction::Up, hidden: true)

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
