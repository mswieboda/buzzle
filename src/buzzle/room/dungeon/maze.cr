module Buzzle::Room::Dungeon
  class Maze < Room::Base
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player

      doors = {
        :ice  => Door::Gate.new(2, height, direction: Direction::Up).as(Door::Base),
        :gate => Door::Gate.new(6, 1, darkness: false),
        :exit => Door::Gate.new(5, -1, darkness: false),
      }

      # floors
      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          entities << Floor::Base.new(x, y)
        end
      end

      # maze walls
      entities += add_left_wall(2, 9)
      entities += add_left_wall(1, 8)

      # wall torch (switch)
      @wall_switch = WallTorch.new(0, 8, on: false, actionable: true)
      entities << @wall_switch

      # maze walls
      (width - 1).times do |x|
        entities += add_down_wall(x, 7)
      end

      # maze walls
      (1..width - 1).each do |x|
        entities += add_down_wall(x, 6)
      end

      # maze walls
      y = 5
      width.times do |x|
        entities += add_down_wall(x, y) unless x == 3 || x == 7
      end
      [3, 7].each do |x|
        entities += add_left_wall(x, y)
        entities += add_right_wall(x, y)
      end

      # maze walls
      y = 4
      [3, 7].each do |x|
        entities += add_left_wall(x, y)
        entities += add_right_wall(x, y)
      end
      entities += add_right_wall(0, y)
      [1, 3, 6, 9].each do |x|
        entities += add_down_wall(x, y)
      end

      # maze walls
      y = 3
      [2, 4, 6, 8].each do |x|
        entities += add_down_wall(x, y)
      end
      [5, 9].each do |x|
        entities += add_left_wall(x, y)
      end
      entities += add_right_wall(0, y)

      # maze walls
      y = 2
      entities += add_right_wall(0, y)

      # maze walls
      y = 1
      entities += add_right_wall(5, y)
      entities << Wall.new(6, y + 1, direction: Direction::Up, enabled: false)
      [7, 8].each do |x|
        entities += add_down_wall(x, y)
      end
      entities += add_left_wall(9, y)

      # lever
      @lever = Lever.new(7, 1)
      entities << @lever

      # maze walls
      entities += add_right_wall(5, 0)
      entities += add_down_wall(9, 0)

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

      doors[:gate].open if @wall_switch.on?
      doors[:gate].close if @wall_switch.off?

      doors[:exit].open if @lever.on?
      doors[:exit].close if @lever.off?
    end
  end
end
