module Buzzle
  class Game < Game
    DEBUG = false

    TARGET_FPS = 60
    DRAW_FPS   = DEBUG

    GRID_SIZE = 32

    @@pause_player_input = false

    def initialize
      super(
        name: "Buzzle",
        target_fps: TARGET_FPS,
        audio: true,
        debug: DEBUG,
        draw_fps: DEBUG
      )

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
          {asset_file: "spike", frames: 4, rows: 1},
          {asset_file: "sign", frames: 1, rows: 1},
        ]
      )
    end

    def load_sounds
      Sound.load([
        {name: "footstep-1", filename: "../assets/sounds/footstep-1.wav", volume: 0.125_f32, pitch: nil},
        {name: "footstep-2", filename: "../assets/sounds/footstep-2.wav", volume: 0.125_f32, pitch: nil},
        {name: "footstep-3", filename: "../assets/sounds/footstep-3.wav", volume: 0.125_f32, pitch: nil},
        {name: "footstep-4", filename: "../assets/sounds/footstep-4.wav", volume: 0.125_f32, pitch: nil},
        {name: "switch start", filename: "../assets/sounds/footstep-1.wav", volume: 0.125_f32, pitch: 0.5_f32},
        {name: "switch done", filename: "../assets/sounds/footstep-1.wav", volume: 0.5_f32, pitch: 3.5_f32},
        {name: "pressure switch", filename: "../assets/sounds/footstep-1.wav", volume: 0.75_f32, pitch: 0.33_f32},
        {name: "gate", filename: "../assets/sounds/footstep-1.wav", volume: 0.75_f32, pitch: 0.75_f32},
      ])
    end

    def update(frame_time)
      @scene_manager.update(frame_time)
    end

    def draw
      @scene_manager.draw
    end

    def self.pause_player_input?
      @@pause_player_input
    end

    def self.pause_player_input=(pause)
      @@pause_player_input = pause
    end
  end
end
