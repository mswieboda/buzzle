module Buzzle::Scene
  class Scene1 < Base
    def initialize(@player)
      super(@player)

      @rooms[:entrance] = Room::Scene1::Entrance.new(@player)
      @rooms[:room_1] = Room::Scene1::Room1.new(@player)
      @rooms[:room_2] = Room::Scene1::Room2.new(@player)

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

      change_rooms(:entrance, :room_1)
      change_rooms(:room_1, :room_2)
    end

    def next_scene?
      @rooms[:room_2].doors[:exit].entered?(@player)
    end
  end
end
