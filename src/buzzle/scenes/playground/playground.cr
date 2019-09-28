module Buzzle::Scenes
  class Playground < Scene
    def initialize(@player)
      super(@player)

      @rooms[:playground] = Rooms::Main.new(@player)
      @rooms[:house] = Rooms::House.new(@player)
      @rooms[:dead_end] = Rooms::DeadEnd.new(@player)

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

      change_rooms(:playground, :house)
      change_rooms(:playground, :dead_end)

      change_rooms({room: :playground, door: :up}, {room: :playground, door: :down})
      change_rooms({room: :playground, door: :right}, {room: :playground, door: :left})
    end

    def next_scene?
      @rooms[:dead_end].doors[:exit].entered?(@player)
    end
  end
end
