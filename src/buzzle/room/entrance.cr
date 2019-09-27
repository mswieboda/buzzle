module Buzzle::Room
  class Entrance < Base
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player

      doors = {
        :room_1 => Door::Gate.new(3, -1, open: true).as(Door::Base),
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
          # skip if river
          next if y == 3
          entities << Floor::Grass.new(x, y)
        end
      end

      # block
      entities << Block.new(7, 7)

      # river
      (0..width - 1).each do |x|
        entities << Floor::River.new(x, 3)
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
