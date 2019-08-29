module Buzzle
  class Entity < Obj
    def initialize(x : Int32 | Float32, y : Int32 | Float32, @z = 1, @width = 0, @height = 0)
      super
      @trigger = Trigger.new(enabled: false)
    end

    def facing?(player : Player)
      if player.x < x
        player.y == y && player.direction.right?
      elsif player.x > x
        player.y == y && player.direction.left?
      else
        if player.y < y
          player.direction.down?
        elsif player.y > y
          player.direction.up?
        else
          # player is standing on (x, y)
          true
        end
      end
    end

    def trigger?(entity : Entity)
      return unless @trigger.enabled?

      @trigger.trigger?(entity)
    end

    def trigger_facing?(player : Player)
      trigger?(player) && facing?(player)
    end

    def update(frame_time, _entities)
      update(frame_time)
    end

    def update(_frame_time)
      @trigger.update(self)
    end
  end
end
