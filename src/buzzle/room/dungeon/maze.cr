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
      entities << Wall.new(1, 9, direction: Direction::Right, hidden: true)
      entities << Wall.new(2, 9, direction: Direction::Left)
      entities << Wall.new(0, 8, direction: Direction::Right, hidden: true)
      entities << Wall.new(1, 8, direction: Direction::Left)

      # wall torch (switch)
      entities << WallTorch.new(0, 8, on: false, actionable: true)

      # maze walls
      y = 7
      (width - 1).times do |x|
        entities << Wall.new(x, y + 1, direction: Direction::Up)
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      # maze walls
      y = 6
      (1..width - 1).each do |x|
        entities << Wall.new(x, y + 1, direction: Direction::Up)
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      # maze walls
      y = 5
      width.times do |x|
        next if x == 7 || x == 3
        entities << Wall.new(x, y + 1, direction: Direction::Up)
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      # maze walls
      [3, 7].each do |x|
        [5, 4].each do |y|
          entities << Wall.new(x - 1, y, direction: Direction::Right, hidden: true)
          entities << Wall.new(x + 1, y, direction: Direction::Left, hidden: true)

          entities << Wall.new(x, y, direction: Direction::Right)
          entities << Wall.new(x, y, direction: Direction::Left)
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

    def update(frame_time)
      super
    end
  end
end
