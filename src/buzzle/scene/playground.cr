module Buzzle::Scene
  class Playground < Base
    def initialize(@player)
      super(@player)

      @rooms[:main] = Room::Playground::Main.new(@player)
      @rooms[:dead_end] = Room::Playground::DeadEnd.new(@player)
      @rooms[:locked_pits] = Room::Playground::LockedPits.new(@player)

      @room = @rooms[:main]
    end

    def load
      @room = @rooms[:main]

      @player.initial_location(
        x: 3 * Game::GRID_SIZE,
        y: 3 * Game::GRID_SIZE,
        z: 0
      )

      super
    end

    def update(frame_time)
      super

      change_rooms(:main, :dead_end)
      change_rooms(:main, :locked_pits)

      change_rooms({room: :main, door: :up}, {room: :main, door: :down})
      change_rooms({room: :main, door: :right}, {room: :main, door: :left})
    end

    def next_scene?
      @rooms[:locked_pits].doors[:exit].entered?(@player)
    end
  end
end
