module Buzzle
  class Scene
    getter player : Player
    getter? loaded

    def initialize(@player)
      @room = Room::Base.new(@player)

      @rooms = [] of Room::Base
      @rooms << @room

      @loaded = false
    end

    def load
      @loaded = true
    end

    def unload
      @loaded = false
    end

    def update(frame_time)
      load unless loaded?

      @room.update(frame_time)
    end

    def draw
      @room.draw
    end

    def change_room(room : Room::Base)
      @room = room
    end

    def change_room(room : Room::Base, door : Door::Base)
      change_room(room: room)
      @player.enter(door, instant: true)
    end

    def change_rooms(player : Player, door : Door::Base, room : Room::Base, next_room : Room::Base, next_door : Door::Base)
      change_room(room: next_room, door: next_door) if door.entered?(player) if @room == room
      change_room(room: room, door: door) if next_door.entered?(player) if @room == next_room
    end

    def next_scene?
      false
    end
  end
end
