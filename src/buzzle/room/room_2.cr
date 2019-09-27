module Buzzle::Room
  class Room2 < Base
    def initialize(player, entities = [] of Entity, width = 15, height = 15)
      puts "Room2#initialize"
      @entities = [] of Entity
      @entities += entities
      @entities << player

      # outer walls
      ((0..width - 1).to_a).each do |x|
        @entities << Wall.new(x, -1, design: rand > 0.5 ? 0 : rand(6))
      end

      # floors
      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          @entities << Floor::Base.new(x, y)
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
