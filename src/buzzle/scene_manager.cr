module Buzzle
  class SceneManager
    @scene : Scene

    RESPAWN_TIMER = 3

    def initialize(@player : Player)
      @scene_index = 0

      @scenes = [] of Scene.class
      @scenes << Scenes::Scene1
      @scenes << Scenes::Playground

      puts @scenes.class

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
        puts "via SceneManager#next_scene --- No more scenes, game over?"
        @scene_index = 0
      end

      @scene.unload
      @scene = @scenes[@scene_index].new(@player)
    end
  end
end
