module Buzzle::Scene
  class Base
    getter player : Player
    getter? loaded

    @rooms : Hash(Symbol, Room::Base)

    def initialize(@player)
      @rooms = Hash(Symbol, Room::Base).new
      @room = Room::Base.new(@player)

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

    def room?(room : Symbol)
      @room == @rooms[room]
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
