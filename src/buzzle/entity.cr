module Buzzle
  class Entity < Obj
    getter? lifting

    def initialize(x : Int32 | Float32, y : Int32 | Float32, z = 0, width = 0, height = 0, direction = Direction::Down, hidden = false)
      super
      @lifting = false
      @trigger = Trigger.new(enabled: false)
    end

    def entities
      [self]
    end

    def actionable?
      false
    end

    def action
    end

    def actionable_condition?(entity : Entity)
      trigger_facing?(entity)
    end

    def liftable?
      false
    end

    def ascend
      @z += 1
    end

    def descend
      @z -= 1
    end

    def lift(amount)
      @lifting = true
      @y += amount
    end

    def lift_stopped
      @lifting = false
    end

    def trigger?(entity : Entity)
      @trigger.trigger?(entity)
    end

    def trigger_facing?(entity : Entity, opposite = false)
      trigger?(entity) && entity.facing?(self, opposite)
    end

    def update(frame_time, _entities)
      update(frame_time)
    end

    def update(_frame_time)
      @trigger.update(self)
    end

    def draw(screen_x, screen_y)
      @trigger.draw(screen_x, screen_y) if Game::DEBUG
    end
  end
end
