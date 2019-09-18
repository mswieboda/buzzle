module Buzzle
  class SceneManager
    @scene : Scene

    RESPAWN_TIMER = 3

    def initialize(@player : Player)
      @scene_index = 0

      @scenes = [] of Scene
      @scenes << Scenes::Scene1.new(@player)
      @scenes << Scenes::Playground.new(@player)

      @scene = @scenes[0]

      @respawn_timer = Timer.new(RESPAWN_TIMER)
    end

    def update(frame_time)
      @scene.update(frame_time)

      if @player.dead?
        @respawn_timer.increase(frame_time)

        if @respawn_timer.done?
          @respawn_timer.reset
          respawn
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
      @scene = @scenes[@scene_index]
    end

    def respawn
      @player.revive
      @scene.load
    end
  end
end
