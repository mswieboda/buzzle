module Buzzle::Scenes
  class Playground < Scene
    def initialize(@player)
      # Playground
      @door = Door.new(3, 0)
      @switch = Switch.new(10, 3)
      entities = [@door, @switch]

      @room1 = Rooms::Playground.new(@player, entities)

      # House
      @door2 = Door.new(5, 0)
      entities = [@door2]

      @room2 = Rooms::House.new(@player, entities)

      @rooms = [] of Room
      @rooms = [@room1, @room2]

      @room = @room1
    end

    def update(frame_time)
      @door.open if @switch.on?
      @door.close if @switch.off?

      change_room(room: @room2, door: @door2) if @door.trigger?(@player)
      change_room(room: @room1, door: @door) if @door2.trigger?(@player)

      @room.update(frame_time)
    end
  end
end
