module Buzzle::Scenes::Playground::Rooms
  class DeadEnd < Room::Base
    def initialize(player, width = 8, height = 4)
      entities = [] of Entity
      entities << player

      doors = {
        :playground => Door::Wooden.new(5, -1),
        :exit       => Door::Locked.new(1, -1),
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
