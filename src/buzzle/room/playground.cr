module Buzzle::Room
  class Playground < Base
    def initialize(player, entities = [] of Entity, width = 15, height = 15)
      @entities = [] of Entity
      @entities += entities
      @entities << player
      @entities << Block.new(5, 3)
      @entities << Block.new(3, 5)

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          if x == 5 && y == 8
            @entities << Floor::Pit.new(x, y)
          elsif y >= 11 && y < height - 1 && x >= 3 && x < width - 1
            @entities << Floor::Ice.new(x, y)
          else
            @entities << Floor::Base.new(x, y)
          end
        end
      end

      @entities << Pillar.new(3, 3, 1, direction: Direction::Up)
      @entities << Pillar.new(3, 4)

      @entities << Wall.new(5, 6, direction: Direction::Left)
      @entities << Wall.new(5, 6, railing: true)
      @entities << Wall.new(5, 6, direction: Direction::Up)
      @entities << Wall.new(5, 6, 1, direction: Direction::Up)
      @entities << Floor::Base.new(5, 6, 1)
      @entities << Wall.new(6, 6, railing: true)
      @entities << Wall.new(6, 6, direction: Direction::Up)
      @entities << Wall.new(6, 6, 1, direction: Direction::Up)
      @entities << Floor::Base.new(6, 6, 1)
      @entities << WallLadder.new(7, 7)
      @entities << Ladder.new(7, 7, 1, ascend: false)
      @entities << Wall.new(7, 6, direction: Direction::Up)
      @entities << Wall.new(7, 6, 1, direction: Direction::Up)
      @entities << Floor::Base.new(7, 6, 1)
      @entities << Wall.new(8, 6, direction: Direction::Up)
      @entities << Wall.new(8, 6, 1, direction: Direction::Up)
      @entities << Floor::Base.new(8, 6, 1)
      @entities << Wall.new(8, 6, direction: Direction::Right)

      @lift = Lift.new(4, 7, auto: false)
      @entities << @lift
      @entities << Lift.new(6, 8)

      @lift_lever = Lever.new(6, 8)
      @entities << @lift_lever

      @entities << Chest.new(9, 9)

      ((0..2).to_a + [4] + (6..width - 1).to_a).each do |x|
        @entities << Wall.new(x, -1, design: rand > 0.5 ? 0 : rand(6))
      end

      # on ice
      @entities << Block.new(5, 12)
      @entities << Floor::Spikes.new(12, 12)

      super(
        player: player,
        entities: @entities,
        width: width,
        height: height
      )
    end

    def update(frame_time)
      super

      @lift.raise if @lift_lever.on?
      @lift.lower if @lift_lever.off?
    end
  end
end
