module Buzzle::Room
  class Room2 < Base
    def initialize(player, width = 15, height = 15)
      entities = [] of Entity
      entities << player

      doors = {
        :room_1 => Door::Gate.new(5, height, direction: Direction::Up).as(Door::Base),
        :exit   => Door::Gate.new(3, -1).as(Door::Base),
      }

      # outer walls
      width.times do |x|
        y = -1
        next if doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      # floors
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
    end
  end
end
