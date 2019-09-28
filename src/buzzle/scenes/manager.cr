module Buzzle::Scenes
  class Manager
    @player : Player
    @scene : Scene

    RESPAWN_TIMER = 3

    def initialize
      @player = Player.new
      @heads_up_display = HeadsUpDisplay.new(@player)

      @scene_index = 0

      @scenes = [] of Scene.class
      @scenes << Scene1
      @scenes << Playground

      @scene = @scenes[@scene_index].new(@player)

      @respawn_timer = Timer.new(RESPAWN_TIMER)
    end

    def update(frame_time)
      @scene.update(frame_time)
      @heads_up_display.update(frame_time)

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
      @heads_up_display.draw
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
