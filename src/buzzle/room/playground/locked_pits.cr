module Buzzle::Room::Playground
  class LockedPits < Room::Base
    def initialize(player, width = 8, height = 4)
      entities = [] of Entity
      entities << player

      doors = {
        :main => Door::Wooden.new(5, -1),
        :exit => Door::Locked.new(1, -1),
      }

      entities << Floor::Base.new(0, 0)
      entities << Floor::Base.new(width - 1, 0)

      (1..width - 2).each do |x|
        (0..height - 2).each do |y|
          entities << Floor::Base.new(x, y)
        end
      end

      [0, width - 1].each do |x|
        (1..height - 1).each do |y|
          entities << Floor::Pit.new(x, y)
        end
      end

      (0..width - 1).each do |x|
        entities << Floor::Pit.new(x, height - 1)
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
