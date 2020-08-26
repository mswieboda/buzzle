module Buzzle
  class Sound
    @@sounds = Hash(String, LibRay::Sound).new

    def self.load(sounds : Array(NamedTuple(name: String, asset_file: String, volume: Float32 | Nil, pitch: Float32 | Nil)))
      sounds.each { |sound| load(sound[:name], sound[:asset_file], sound[:volume], sound[:pitch]) }
    end

    def self.load(name : String, asset_file : String, volume : Float32 | Nil, pitch : Float32 | Nil)
      return if @@sounds.has_key?(name)

      file_path = File.join(__DIR__, "../../assets/sounds/#{asset_file}.wav")
      sound = LibRay.load_sound(file_path)

      @@sounds[name] = sound
    end

    def self.get(name)
      sound = @@sounds[name]

      unless sound
        raise "sound: #{name} not found, make sure to load first with Sound.load before using"
      end

      sound
    end

    def self.unload_all
      @@sounds.each do |(asset_file, sound)|
        stop(sound) if playing?(sound)
      end

      @@sounds.each do |(asset_file, sound)|
        unload(sound)
      end
    end

    def self.playing?(sound)
      LibRay.sound_playing?(sound)
    end

    def self.play(sound)
      LibRay.play_sound(sound)
    end

    def self.stop(sound)
      LibRay.stop_sound(sound)
    end

    def self.pause(sound)
      LibRay.pause_sound(sound)
    end

    def self.resume(sound)
      LibRay.resume_sound(sound)
    end

    def self.unload(sound)
      LibRay.unload_sound(sound)
    end

    def self.play_random_pitch(sound, min = 0.5_f32)
      pitch = (min + rand(1.0)).to_f32
      LibRay.set_sound_pitch(sound, pitch)
      play(sound)
    end
  end
end
