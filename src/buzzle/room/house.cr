module Buzzle::Room
  class House < Base
    def initialize(player, width = 8, height = 4)
      entities = [] of Entity
      entities << player

      doors = {
        :playground => Door::Gate.new(3, -1).as(Door::Base),
      }

      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          entities << Floor::Base.new(x, y)
        end
      end

      width.times do |x|
        y = -1
        next if doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      super(
        player: player,
        entities: entities,
        doors: doors,
        width: width,
        height: height
      )
    end
  end
end
