module Buzzle::Room::Playground
  class DeadEnd < Room::Base
    def initialize(player, width = 8, height = 4)
      entities = [] of Entity
      entities << player

      doors = {
        :main => Door::Gate.new(3, -1).as(Door::Base),
      }

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          entities << Floor::Base.new(x, y)
        end
      end

      super(
        player: player,
        entities: entities,
        doors: doors,
        width: width,
        height: height
      )

      add_border_walls
    end
  end
end
