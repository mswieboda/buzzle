module Buzzle::Scenes
  class Scene1 < Scene
    def initialize(@player)
      super(@player)
      @rooms = [] of Room::Base

      # Entrance
      @door_entrance = Door::Gate.new(3, -1, open: true)
      @rooms << Room::Entrance.new(@player, entities: [@door_entrance])

      # Room 1
      @door_exit = Door::Gate.new(5, 10, direction: Direction::Up)
      @door1_1 = Door::Gate.new(3, -1)
      @lever = Lever.new(7, 3)
      @pressure_switch = PressureSwitch.new(5, 5)
      @rooms << Room::Room1.new(@player, entities: [@door_exit, @door1_1, @lever, @pressure_switch])

      @room = @rooms.first
    end

    def load
      @room = @rooms[0]

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

      # Entrance
      change_rooms(player: @player, door: @door_entrance, room: @rooms[0], next_room: @rooms[1], next_door: @door_exit)

      # TODO: refactor rooms to output doors like @rooms[:entrance].scene_doors[:entrance1]
      #       and move non-needed stuff to rooms, like these switches since the doors
      #       be accessible from the room

      # Room 1
      if @room == @rooms[1]
        @door1_1.open if @lever.on?
        @door1_1.close if @lever.off?

        unless @door1_1.active?
          @lever.switch if @pressure_switch.off? && @lever.on?
        end
      end
    end

    def next_scene?
      @door1_1.entered?(@player)
    end
  end
end
