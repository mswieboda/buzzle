module Buzzle
  class Game
    SCREEN_WIDTH  = 1280
    SCREEN_HEIGHT =  768

    DEBUG = false

    TARGET_FPS = 60
    DRAW_FPS   = DEBUG

    GRID_SIZE = 32

    def initialize
      LibRay.init_window(SCREEN_WIDTH, SCREEN_HEIGHT, "Buzzle")
      LibRay.init_audio_device
      LibRay.set_target_fps(TARGET_FPS)

      load_sprites
      load_sounds

      @player = Player.new(3, 3)
      @scene = Scenes::Playground.new(@player)

      @scenes = [] of Scene
      @scenes << @scene
    end

    def load_sprites
      # attempt to load all sprites before loading any levels or intializing
      # any classes that use a sprite internally
      Sprite.load(
        [
          {asset_file: "player", frames: 6, rows: 4},
          {asset_file: "door", frames: 4, rows: 1},
          {asset_file: "block", frames: 1, rows: 1},
          {asset_file: "switch", frames: 7, rows: 1},
          {asset_file: "floor", frames: 1, rows: 1},
          {asset_file: "wall", frames: 6, rows: 1},
          {asset_file: "ladder", frames: 1, rows: 1},
        ]
      )
    end

    def load_sounds
      Sound.load([
        {name: "footstep-1", asset_file: "footstep-1", volume: 0.125_f32, pitch: nil},
        {name: "footstep-2", asset_file: "footstep-2", volume: 0.125_f32, pitch: nil},
        {name: "footstep-3", asset_file: "footstep-3", volume: 0.125_f32, pitch: nil},
        {name: "footstep-4", asset_file: "footstep-4", volume: 0.125_f32, pitch: nil},
        {name: "switch", asset_file: "footstep-1", volume: nil, pitch: 3.5_f32},
      ])
    end

    def run
      while !LibRay.window_should_close?
        frame_time = LibRay.get_frame_time
        update(frame_time)
        draw_init
      end

      close
    end

    def update(frame_time)
      @scene.update(frame_time)
    end

    def draw
      @scene.draw
    end

    def draw_init
      LibRay.begin_drawing
      LibRay.clear_background LibRay::BLACK

      draw

      LibRay.draw_fps(0, 0) if DRAW_FPS
      LibRay.end_drawing
    end

    def close
      Sound.unload_all

      LibRay.close_audio_device

      LibRay.close_window
    end
  end
end
