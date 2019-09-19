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

      @scene_manager = Scene::Manager.new
    end

    def load_sprites
      # attempt to load all sprites before loading any levels or intializing
      # any classes that use a sprite internally
      Sprite.load(
        [
          {asset_file: "player", frames: 6, rows: 4},
          {asset_file: "door", frames: 5, rows: 16},
          {asset_file: "block", frames: 1, rows: 1},
          {asset_file: "switch", frames: 7, rows: 2},
          {asset_file: "floor", frames: 5, rows: 1},
          {asset_file: "accents", frames: 32, rows: 3},
          {asset_file: "wall", frames: 2, rows: 6},
          {asset_file: "chest", frames: 6, rows: 1},
          {asset_file: "key", frames: 1, rows: 1},
          {asset_file: "torch", frames: 4, rows: 3},
        ]
      )
    end

    def load_sounds
      Sound.load([
        {name: "footstep-1", asset_file: "footstep-1", volume: 0.125_f32, pitch: nil},
        {name: "footstep-2", asset_file: "footstep-2", volume: 0.125_f32, pitch: nil},
        {name: "footstep-3", asset_file: "footstep-3", volume: 0.125_f32, pitch: nil},
        {name: "footstep-4", asset_file: "footstep-4", volume: 0.125_f32, pitch: nil},
        {name: "switch start", asset_file: "footstep-1", volume: 0.125_f32, pitch: 0.5_f32},
        {name: "switch done", asset_file: "footstep-1", volume: 0.5_f32, pitch: 3.5_f32},
        {name: "pressure switch", asset_file: "footstep-1", volume: 0.75_f32, pitch: 0.33_f32},
        {name: "gate", asset_file: "footstep-1", volume: 0.75_f32, pitch: 0.75_f32},
      ])
    end

    def run
      while !LibRay.window_should_close?
        frame_time = LibRay.get_frame_time
        update(frame_time)
        draw_wrapper
      end

      close
    end

    def update(frame_time)
      @scene_manager.update(frame_time)
    end

    def draw
      @scene_manager.draw
    end

    def draw_wrapper
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
