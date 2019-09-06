module Buzzle::Scenes
  class Playground < Scene
    def initialize(@player)
      super(@player)

      # Playground
      @door1_1 = Door.new(3, 0, design: Door::Type::Gate)
      @door1_2 = Door.new(8, 7, open: true)
      @switch = Switch.new(10, 3)
      @pressure_switch = PressureSwitch.new(7, 3)
      @room1 = Rooms::Playground.new(@player, entities: [@door1_1, @door1_2, @switch, @pressure_switch])

      # House
      @door2_1 = Door.new(5, 0, design: Door::Type::Gate)
      @room2 = Rooms::House.new(@player, entities: [@door2_1])

      @door3_1 = Door.new(5, 0)
      @door3_2 = LockedDoor.new(1, 0)
      @room3 = Rooms::DeadEnd.new(@player, entities: [@door3_1, @door3_2])

      @rooms = [] of Room
      @rooms = [@room1, @room2, @room3]

      @room = @room1
    end

    def load
      @room = @room1

      @player.initial_location(
        x: 3 * Game::GRID_SIZE,
        y: 3 * Game::GRID_SIZE,
        z: 0
      )

      super
    end

    def update(frame_time)
      super

      @door1_1.open if @switch.on?
      @door1_1.close if @switch.off?

      @door1_2.open if @pressure_switch.on?
      @door1_2.close if @pressure_switch.off?

      change_rooms(player: @player, door: @door1_1, room: @room1, next_room: @room2, next_door: @door2_1)
      change_rooms(player: @player, door: @door1_2, room: @room1, next_room: @room3, next_door: @door3_1)
    end

    def next_scene?
      @door3_2.entered?(@player)
    end
  end
end
