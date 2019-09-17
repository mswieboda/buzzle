module Buzzle
  class Timer
    getter time : Float32
    getter length : Float64 | Float32 | Int32
    getter? started

    def initialize(@length : Float64 | Float32 | Int32, start_time = 0_f32)
      @started = false
      @time = start_time
    end

    def start
      @started = true
    end

    def progressing?
      @started && @time < @length
    end

    def done?
      started? && @time >= @length
    end

    def reset(start_time = 0_f32)
      @started = false
      @time = start_time
    end

    def restart(start_time = 0_f32)
      reset(start_time)
      start
    end

    def increase(delta_t : Float32)
      start unless started?
      @time += delta_t
    end

    def percentage
      @time / @length
    end

    def toggle?
      percentage > 0.5
    end
  end
end
