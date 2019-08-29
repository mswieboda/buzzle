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

    def change_rooms(player : Player, door : Door, room : Room, next_room : Room, next_door : Door)
      change_room(room: next_room, door: next_door) if door.entered?(player) if @room == room
      change_room(room: room, door: door) if next_door.entered?(player) if @room == next_room
    end
  end
end
