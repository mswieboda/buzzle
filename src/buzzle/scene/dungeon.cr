module Buzzle::Scene
  class Dungeon < Base
    def initialize(@player)
      super(@player)

      @rooms[:entrance] = Room::Dungeon::Entrance.new(@player)
      @rooms[:dark] = Room::Dungeon::Dark.new(@player)
      @rooms[:ice] = Room::Dungeon::Ice.new(@player)

      @room = @rooms[:entrance]
    end

    def load
      @room = @rooms[:entrance]

      @player.initial_location(
        x: 5 * Game::GRID_SIZE,
        y: 8 * Game::GRID_SIZE,
        z: 0
      )

      @player.face(Direction::Up)

      super
    end

    def update(frame_time)
      super

      change_rooms(:entrance, :dark)
      change_rooms(:dark, :ice)
    end

    def next_scene?
      @rooms[:ice].doors[:exit].entered?(@player)
    end
  end
end
