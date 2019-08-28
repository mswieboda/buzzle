module Buzzle::Scenes
  class Playground < Scene
    def initialize(@player)
      @door = Door.new(3 * Game::GRID_SIZE, 0)
      @door2 = Door.new(13 * Game::GRID_SIZE, 0)
      @switch = Switch.new(10 * Game::GRID_SIZE, 3 * Game::GRID_SIZE)

      entities = [] of Entity
      entities << @door
      entities << @door2
      entities << @switch

      @room = Rooms::Playground.new(@player, entities, width: Game::SCREEN_WIDTH, height: Game::SCREEN_HEIGHT)

      @rooms = [] of Room
      @rooms << @room
    end

    def update(frame_time)
      @door.open if @switch.on?
      @door.close if @switch.off?

      if @door.trigger?(@player)
        @player.enter(to: @door2, from: @door)
      end

      if @door2.trigger?(@player)
        @player.enter(to: @door, from: @door2)
      end

      @room.update(frame_time)
    end
  end
end
