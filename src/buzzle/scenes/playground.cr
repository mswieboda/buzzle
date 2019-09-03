module Buzzle::Scenes
  class Playground < Scene
    def initialize(@player)
      # Playground
      @door1_1 = Door.new(3, 0, design: Door::Type::Gate)
      @door1_2 = Door.new(8, 7, open: true)
      @switch = Switch.new(10, 3)
      @pressure_switch = PressureSwitch.new(7, 3)
      @room1 = Rooms::Playground.new(@player, entities: [@door1_1, @door1_2, @switch, @pressure_switch])

      # House
      @door2_1 = Door.new(5, 0)
      @room2 = Rooms::House.new(@player, entities: [@door2_1])

      @door3_1 = Door.new(5, 0)
      @room3 = Rooms::DeadEnd.new(@player, entities: [@door3_1])

      @rooms = [] of Room
      @rooms = [@room1, @room2, @room3]

      @room = @room1
    end

    def update(frame_time)
      @door1_1.open if @switch.on?
      @door1_1.close if @switch.off?

      @door1_2.open if @pressure_switch.on?
      @door1_2.close if @pressure_switch.off?

      change_rooms(player: @player, door: @door1_1, room: @room1, next_room: @room2, next_door: @door2_1)
      change_rooms(player: @player, door: @door1_2, room: @room1, next_room: @room3, next_door: @door3_1)

      @room.update(frame_time)
    end
  end
end
