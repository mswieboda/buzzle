module Buzzle::Room::Dungeon
  class Dark < Room::Dark
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player

      doors = {
        :entrance => Door::Gate.new(5, height, direction: Direction::Up).as(Door::Base),
        :ice      => Door::Gate.new(3, -1).as(Door::Base),
      }

      @lever = Lever.new(7, 3)
      entities << @lever

      @pressure_switch = PressureSwitch.new(5, 5)
      entities << @pressure_switch

      # outer walls
      width.times do |x|
        y = -1
        entities << Wall.new(x, y + 1, direction: Direction::Up)
        next if doors.values.any? { |d| d.x / Game::GRID_SIZE == x && d.y / Game::GRID_SIZE == y }
        entities << Wall.new(x, y, design: rand > 0.5 ? 0 : rand(6))
      end

      height.times do |y|
        x = -1
        entities << Wall.new(x, y, direction: Direction::Right)

        x = width
        entities << Wall.new(x, y, direction: Direction::Left)
      end

      # floors
      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          entities << Floor::Base.new(x, y)
        end
      end

      entities << Pillar.new(3, 3, 1, direction: Direction::Up)
      entities << Pillar.new(3, 4)

      # block
      entities << Block.new(5, 3)

      # torches
      entities << Torch.new(5, 6)
      entities << WallTorch.new(4, 0)
      entities << WallTorch.new(2, 0)

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

      doors[:ice].open if @lever.on?
      doors[:ice].close if @lever.off?

      unless doors[:ice].active?
        @lever.switch if @pressure_switch.off? && @lever.on?
      end
    end
  end
end
