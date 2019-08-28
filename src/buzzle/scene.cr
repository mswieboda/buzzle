module Buzzle
  class Scene
    getter player : Player

    def initialize(@player)
      @room = Room.new(@player)

      @rooms = [] of Room
      @rooms << @room
    end

    def update(frame_time)
      @room.update(frame_time)
    end

    def draw
      @room.draw
    end

    def change_room(room : Room)
      @room = room
    end

    def change_room(room : Room, door : Door)
      change_room(room: room)
      @player.enter(door, instant: true)
    end
  end
end
