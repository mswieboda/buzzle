module Buzzle::Room::Dungeon
  class Maze < Room::Base
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player

      doors = {
        :ice => Door::Gate.new(2, height, direction: Direction::Up).as(Door::Base),
      }

      # floors
      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          entities << Floor::Base.new(x, y)
        end
      end

      # maze walls
      (width - 1).times do |x|
        y = 7
        next if doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
        entities << Wall.new(x, y + 1, direction: Direction::Up)
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

    def update(frame_time)
      super
    end
  end
end
