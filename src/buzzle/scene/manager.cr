module Buzzle::Scene
  class Manager
    @scene : Base

    RESPAWN_TIMER = 3

    def initialize(@player : Player)
      @scene_index = 0

      @scenes = [] of Base.class
      @scenes << Scene1
      @scenes << Playground

      @scene = @scenes[0].new(@player)

      @respawn_timer = Timer.new(RESPAWN_TIMER)
    end

    def update(frame_time)
      @scene.update(frame_time)

      if @player.dead?
        @respawn_timer.increase(frame_time)

        if @respawn_timer.done?
          @respawn_timer.reset
          @player.revive
          @scene.initialize(@player)
        end
      end

      next_scene if @scene.next_scene?
    end

    def draw
      @scene.draw
    end

    def next_scene
      @scene_index += 1

      if @scene_index >= @scenes.size
        @scene_index = 0
      end

      @scene.unload
      @scene = @scenes[@scene_index].new(@player)
    end
  end
end
