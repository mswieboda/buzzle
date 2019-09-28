module Buzzle::Room::Dungeon
  class Ice < Room::Base
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player

      doors = {
        :dark => Door::Gate.new(5, height, direction: Direction::Up).as(Door::Base),
        :maze => Door::Gate.new(3, -1).as(Door::Base),
      }

      # top outer walls
      width.times do |x|
        y = -1
        entities << Wall.new(x, y + 1, direction: Direction::Up)
        next if doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      # left/right outer walls
      height.times do |y|
        x = -1
        entities << Wall.new(x, y, direction: Direction::Right)

        x = width
        entities << Wall.new(x, y, direction: Direction::Left)
      end

      # floors
      width.times do |x|
        height.times do |y|
          entities << (x > 1 && x < width - 2 && y > 1 && y < height - 2 ? Floor::Ice : Floor::Base).new(x, y)
        end
      end

      # blocks
      entities << Block.new(1, 3)
      entities << Block.new(3, 5)

      # switches
      @pressure_switch = PressureSwitch.new(5, 5)
      entities << @pressure_switch

      super(
        player: player,
        entities: entities,
        doors: doors,
        width: width,
        height: height
      )
    end

    def update(frame_time)
      super

      doors[:maze].open if @pressure_switch.on?
      doors[:maze].close if @pressure_switch.off?
    end
  end
end
