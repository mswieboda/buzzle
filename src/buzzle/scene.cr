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
  end
end
