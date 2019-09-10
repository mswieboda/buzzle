module Buzzle::Rooms
  class Room1 < Room
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
          @entities << Floor.new(x, y)
        end
      end

      @entities << Pillar.new(3, 4, direction: Direction::Up)
      @entities << Pillar.new(3, 3)

      # block
      @entities << Block.new(5, 3)

      @entities << Torch.new(5, 6, on: true)

      super(
        player: player,
        entities: @entities,
        width: width,
        height: height,
        dark: true
      )
    end
  end
end
