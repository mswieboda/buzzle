module Buzzle::Room
  class Room1 < Dark
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
          @entities << Floor::Base.new(x, y)
        end
      end

      @entities << Pillar.new(3, 3, 1, direction: Direction::Up)
      @entities << Pillar.new(3, 4)

      # block
      @entities << Block.new(5, 3)

      # torches
      @entities << Torch.new(5, 6)
      @entities << WallTorch.new(4, 0)
      @entities << WallTorch.new(2, 0)

      super(
        player: player,
        entities: @entities,
        width: width,
        height: height
      )
    end
  end
end
