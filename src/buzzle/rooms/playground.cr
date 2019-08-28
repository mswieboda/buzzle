module Buzzle::Rooms
  class Playground < Room
    def initialize(@player, @x = 0, @y = 0, @width = 0, @height = 0)
      @door = Door.new(3 * Game::GRID_SIZE, 0)
      @door2 = Door.new(13 * Game::GRID_SIZE, 0)
      @switch = Switch.new(10 * Game::GRID_SIZE, 3 * Game::GRID_SIZE)

      @entities = [] of Entity
      @entities << @door
      @entities << @door2
      @entities << Block.new(5 * Game::GRID_SIZE, 3 * Game::GRID_SIZE)
      @entities << Block.new(7 * Game::GRID_SIZE, 5 * Game::GRID_SIZE)
      @entities << @player
      @entities << @switch
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

      super(frame_time)
    end
  end
end
