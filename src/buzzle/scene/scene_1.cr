module Buzzle::Scene
  class Scene1 < Base
    def initialize(@player)
      super(@player)

      # Entrance
      @door_entrance = Door::Gate.new(3, -1, open: true)
      @rooms[:entrance] = Room::Entrance.new(@player, entities: [@door_entrance])

      # Room 1
      @door_exit = Door::Gate.new(5, 10, direction: Direction::Up)
      @door_1_1 = Door::Gate.new(3, -1)
      @lever = Lever.new(7, 3)
      @pressure_switch = PressureSwitch.new(5, 5)
      @rooms[:room_1] = Room::Room1.new(@player, entities: [@door_exit, @door_1_1, @lever, @pressure_switch])

      @door_2_1 = Door::Wooden.new(5, 10, direction: Direction::Up)
      @rooms[:room_2] = Room::Room2.new(@player, entities: [@door_2_1])

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

      # Entrance to Room 1
      change_rooms(player: @player, door: @door_entrance, room: @rooms[:entrance], next_room: @rooms[:room_1], next_door: @door_exit)

      # Room 1 to 2
      change_rooms(player: @player, door: @door_1_1, room: @rooms[:room_1], next_room: @rooms[:room_2], next_door: @door_2_1)

      # TODO: refactor rooms to output doors like @rooms[:entrance].scene_doors[:entrance1]
      #       and move non-needed stuff to rooms, like these switches since the doors
      #       be accessible from the room

      if room?(:room_1)
        @door_1_1.open if @lever.on?
        @door_1_1.close if @lever.off?

        unless @door_1_1.active?
          @lever.switch if @pressure_switch.off? && @lever.on?
        end
      end
    end
  end
end
