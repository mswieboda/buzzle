module Buzzle::Room
  class Playground < Base
    def initialize(player, width = 15, height = 15)
      entities = [] of Entity
      entities << player

      doors = {
        :house    => Door::Gate.new(3, -1),
        :dead_end => Door::Wooden.new(8, 6, open: true),
        :up       => Door::Gate.new(5, 15, direction: Direction::Up),
        :right    => Door::Wooden.new(-1, 3, direction: Direction::Right),
        :down     => Door::Wooden.new(5, -1),
        :left     => Door::Wooden.new(15, 3, direction: Direction::Left),
      }

      @lever = Lever.new(10, 3)
      entities << @lever

      @pressure_switch = PressureSwitch.new(7, 3)
      entities << @pressure_switch

      entities << Block.new(5, 3)
      entities << Block.new(3, 5)

      width.times do |x|
        height.times do |y|
          if x == 5 && y == 8
            entities << Floor::Pit.new(x, y)
          elsif y >= 11 && y < height - 1 && x >= 3 && x < width - 1
            entities << Floor::Ice.new(x, y)
          else
            entities << Floor::Base.new(x, y)
          end
        end
      end

      entities << Pillar.new(3, 3, 1, direction: Direction::Up)
      entities << Pillar.new(3, 4)

      entities << Wall.new(5, 6, direction: Direction::Left)
      entities << Wall.new(5, 6, railing: true)
      entities << Wall.new(5, 6, direction: Direction::Up)
      entities << Wall.new(5, 6, 1, direction: Direction::Up)
      entities << Floor::Base.new(5, 6, 1)
      entities << Wall.new(6, 6, railing: true)
      entities << Wall.new(6, 6, direction: Direction::Up)
      entities << Wall.new(6, 6, 1, direction: Direction::Up)
      entities << Floor::Base.new(6, 6, 1)
      entities << WallLadder.new(7, 7)
      entities << Ladder.new(7, 7, 1, ascend: false)
      entities << Wall.new(7, 6, direction: Direction::Up)
      entities << Wall.new(7, 6, 1, direction: Direction::Up)
      entities << Floor::Base.new(7, 6, 1)
      entities << Wall.new(8, 6, direction: Direction::Up)
      entities << Wall.new(8, 6, 1, direction: Direction::Up)
      entities << Floor::Base.new(8, 6, 1)
      entities << Wall.new(8, 6, direction: Direction::Right)

      @lift = Lift.new(4, 7, auto: false)
      entities << @lift
      entities << Lift.new(6, 8)

      @lift_lever = Lever.new(6, 8)
      entities << @lift_lever

      entities << Chest.new(9, 9)

      width.times do |x|
        y = -1
        next if doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      # on ice
      entities << Block.new(5, 12)
      entities << Floor::Spikes.new(12, 12)

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

      doors[:house].open if @lever.on?
      doors[:house].close if @lever.off?

      doors[:dead_end].open if @pressure_switch.on?
      doors[:dead_end].close if @pressure_switch.off?

      @lift.raise if @lift_lever.on?
      @lift.lower if @lift_lever.off?
    end
  end
end
