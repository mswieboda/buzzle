module Buzzle::Scenes
  class Scene1 < Scene
    def initialize(@player)
      super(@player)

      @door1_1 = Door.new(3, 0, design: Door::Type::Gate)
      @lever = Lever.new(7, 3)
      @pressure_switch = PressureSwitch.new(5, 5)
      @room1 = Rooms::Room1.new(@player, entities: [@door1_1, @lever, @pressure_switch])

      @rooms = [] of Room
      @rooms << @room1

      @room = @room1
    end

    def load
      @room = @room1

      @player.enter(@door1_1, instant: true)

      super
    end

    def update(frame_time)
      super

      @door1_1.open if @lever.on?
      @door1_1.close if @lever.off?

      unless @door1_1.active?
        @lever.switch if @pressure_switch.off? && @lever.on?
      end
    end

    def next_scene?
      @door1_1.entered?(@player)
    end
  end
end
