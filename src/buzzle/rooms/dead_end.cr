module Buzzle::Rooms
  class DeadEnd < Room
    def initialize(player, entities = [] of Entity, width = 8, height = 4)
      @entities = [] of Entity
      @entities += entities
      @entities << player

      @entities << Floor::Base.new(0, 0)
      @entities << Floor::Base.new(width - 1, 0)

      (1..width - 2).each do |x|
        (0..height - 2).each do |y|
          @entities << Floor::Base.new(x, y)
        end
      end

      [0, width - 1].each do |x|
        (1..height - 1).each do |y|
          @entities << Floor::Pit.new(x, y)
        end
      end

      (0..width - 1).each do |x|
        @entities << Floor::Pit.new(x, height - 1)
      end

      ([0] + (2..4).to_a + (6..width - 1).to_a).each do |x|
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
