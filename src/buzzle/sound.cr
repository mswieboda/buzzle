module Buzzle
  class Sound
    @@sounds = Hash(String, LibRay::Sound).new

    def self.load(sounds : Array(NamedTuple(name: String, asset_file: String, volume: Float32 | Nil, pitch: Float32 | Nil)))
      sounds.each { |sound| load(sound[:name], sound[:asset_file], sound[:volume], sound[:pitch]) }
    end

    def self.load(name : String, asset_file : String, volume : Float32 | Nil, pitch : Float32 | Nil)
      return if @@sounds.has_key?(name)

      ###################
      # TODO: needs fixing as of game/cray upgrade
      ###################

      file_path = File.join(__DIR__, "../../assets/sounds/#{asset_file}.wav")
      # puts ">>> Sound LibRay.load_sound #{file_path}"
      wave = LibRay.load_wave(file_path)
      sound = LibRay.load_sound_ex(wave)
      LibRay.unload_wave(wave)
      # puts ">>> Sound LibRay.set_sound_volume"
      # LibRay.set_sound_volume(sound, volume) if volume
      # puts ">>> Sound LibRay.set_sound_pitch"
      # LibRay.set_sound_pitch(sound, pitch) if pitch
      # puts ">>> Sound set hash"
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
      # TODO: broken, throws invalid mem access error
      #       see self.load above
      # LibRay.sound_playing?(sound)
    end

    def self.play(sound)
      ###################
      # TODO: broken throws invalid mem access error,
      #       see self.load above
      ###################
      # LibRay.play_sound(sound)
    end

    def self.stop(sound)
      ###################
      # TODO: broken throws invalid mem access error,
      #       see self.load above
      ###################
      # LibRay.stop_sound(sound)
    end

    def self.pause(sound)
      ###################
      # TODO: broken throws invalid mem access error,
      #       see self.load above
      ###################
      # LibRay.pause_sound(sound)
    end

    def self.resume(sound)
      ###################
      # TODO: broken throws invalid mem access error,
      #       see self.load above
      ###################
      # LibRay.resume_sound(sound)
    end

    def self.unload(sound)
      ###################
      # TODO: broken throws invalid mem access error,
      #       see self.load above
      ###################
      # LibRay.unload_sound(sound)
    end

    def self.play_random_pitch(sound, min = 0.5_f32)
      ###################
      # TODO: broken throws invalid mem access error,
      #       see self.load above
      ###################
      # pitch = (min + rand(1.0)).to_f32
      # LibRay.set_sound_pitch(sound, pitch)
      # play(sound)
    end
  end
end
