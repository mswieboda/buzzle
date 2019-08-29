module Buzzle::Rooms
  class House < Room
    def initialize(player, entities = [] of Entity, width = 8, height = 4)
      @entities = [] of Entity
      @entities += entities
      @entities << player

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          @entities << Floor.new(x, y)
        end
      end

      ((0..4).to_a + (6..width - 1).to_a).each do |x|
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
