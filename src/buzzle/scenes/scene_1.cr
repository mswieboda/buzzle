module Buzzle::Scenes
  class Scene1 < Scene
    def initialize(@player)
      @door1_1 = Door.new(3, 0, design: Door::Type::Gate)
      @switch = Switch.new(7, 3)
      @pressure_switch = PressureSwitch.new(5, 5)
      @room1 = Rooms::Room1.new(@player, entities: [@door1_1, @switch, @pressure_switch])

      @rooms = [] of Room
      @rooms << @room1

      @room = @room1
    end

    def update(frame_time)
      super

      @door1_1.open if @switch.on?
      @door1_1.close if @switch.off?

      unless @door1_1.switching?
        @switch.switch if @pressure_switch.off? && @switch.on?
      end
    end
  end
end
