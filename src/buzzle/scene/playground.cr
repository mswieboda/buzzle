module Buzzle::Scene
  class Playground < Base
    def initialize(@player)
      super(@player)

      # Playground
      @door1_1 = Door::Gate.new(3, -1)
      @door1_2 = Door::Wooden.new(8, 6, open: true)
      @door_up = Door::Gate.new(5, 15, direction: Direction::Up)
      @door_left = Door::Wooden.new(15, 3, direction: Direction::Left)
      @door_down = Door::Wooden.new(5, -1)
      @door_right = Door::Wooden.new(-1, 3, direction: Direction::Right)
      @lever = Lever.new(10, 3)
      @pressure_switch = PressureSwitch.new(7, 3)
      @rooms[:playground] = Room::Playground.new(@player, entities: [@door1_1, @door1_2, @door_up, @door_left, @door_down, @door_right, @lever, @pressure_switch])

      # House
      @door2_1 = Door::Gate.new(5, -1)
      @rooms[:house] = Room::House.new(@player, entities: [@door2_1])

      @door3_1 = Door::Wooden.new(5, -1)
      @door3_2 = Door::Locked.new(1, -1)
      @rooms[:dead_end] = Room::DeadEnd.new(@player, entities: [@door3_1, @door3_2])

      @room = @rooms[:playground]
    end

    def load
      @room = @rooms[:playground]

      @player.initial_location(
        x: 3 * Game::GRID_SIZE,
        y: 3 * Game::GRID_SIZE,
        z: 0
      )

      super
    end

    def update(frame_time)
      super

      if room?(:playground)
        @door1_1.open if @lever.on?
        @door1_1.close if @lever.off?

        @door1_2.open if @pressure_switch.on?
        @door1_2.close if @pressure_switch.off?
      end

      change_rooms(player: @player, door: @door1_1, room: @rooms[:playground], next_room: @rooms[:house], next_door: @door2_1)
      change_rooms(player: @player, door: @door1_2, room: @rooms[:playground], next_room: @rooms[:dead_end], next_door: @door3_1)

      change_rooms(player: @player, door: @door_up, room: @rooms[:playground], next_room: @rooms[:playground], next_door: @door_down)
      change_rooms(player: @player, door: @door_left, room: @rooms[:playground], next_room: @rooms[:playground], next_door: @door_right)
    end

    def next_scene?
      @door3_2.entered?(@player)
    end
  end
end
