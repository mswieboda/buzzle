module Buzzle::Room::Dungeon
  class Ice < Room::Base
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player

      doors = {
        :dark => Door::Gate.new(5, height, direction: Direction::Up).as(Door::Base),
        :maze => Door::Gate.new(3, -1).as(Door::Base),
      }

      # floors
      width.times do |x|
        height.times do |y|
          entities << (x > 1 && x < width - 2 && y > 1 && y < height - 2 ? Floor::Ice : Floor::Base).new(x, y)
        end
      end

      # blocks
      @blocks = [] of Block
      @blocks << Block.new(1, 3)
      @blocks << Block.new(3, 5)
      entities += @blocks

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

      add_border_walls
    end

    def update(frame_time)
      super

      doors[:maze].open if @pressure_switch.on?
      doors[:maze].close if @pressure_switch.off?

      reset_blocks if doors[:dark].exiting?
    end

    def reset_blocks
      @blocks[0].jump_to(1, 3)
      @blocks[1].jump_to(3, 5)
    end
  end
end
