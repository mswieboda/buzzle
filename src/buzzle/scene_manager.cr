module Buzzle
  class SceneManager
    @scene : Scene

    def initialize(@player : Player)
      @scene_index = 0

      @scene = Scenes::Scene1.new(@player)

      @scenes = [] of Scene
      @scenes << @scene
      @scenes << Scenes::Playground.new(@player)
    end

    def update(frame_time)
      @scene.update(frame_time)

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
  end
end
