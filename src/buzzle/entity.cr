module Buzzle
  class Entity < Obj
    def initialize(x : Int32 | Float32, y : Int32 | Float32, @z = 1, @width = 0, @height = 0)
      super
      @trigger = Trigger.new(enabled: false)
    end

    def trigger?(entity : Entity)
      return unless @trigger.enabled?

      @trigger.trigger?(entity)
    end

    def update(frame_time, _entities)
      update(frame_time)
    end

    def update(_frame_time)
      @trigger.update(self)
    end
  end
end
