module Buzzle
  class Scene
    getter player : Player

    def initialize(@player)
      @room = Rooms::Playground.new(@player, 0, 0, Game::SCREEN_WIDTH, Game::SCREEN_HEIGHT)

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
