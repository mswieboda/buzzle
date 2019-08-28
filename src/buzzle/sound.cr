module Buzzle
  class Sound
    @@sounds = Hash(String, LibRay::Sound).new

    def self.load(asset_files : Array(String))
      asset_files.each { |asset_file| load(asset_file) }
    end

    def self.load(asset_file : String)
      @@sounds[asset_file] ||= LibRay.load_sound(File.join(__DIR__, "../../assets/sounds/#{asset_file}.wav"))
    end

    def self.get(asset_file)
      sound = @@sounds[asset_file]

      unless sound
        raise "sound: #{asset_file} not found, make sure to load first with Sound.load before using"
      end

      sound
    end

    def self.unload_all
      @@sounds.each do |(asset_file, sound)|
        LibRay.unload_sound(sound)
      end
    end
  end
end
