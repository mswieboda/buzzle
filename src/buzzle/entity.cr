module Buzzle
  class Entity < Obj
    getter? lifting

    def initialize(x : Int32 | Float32 = 0, y : Int32 | Float32 = 0, z = 0, width = 0, height = 0, direction = Direction::Down, hidden = false)
      super

      @lifting = false
      @trigger = Trigger.new(enabled: false)
    end

    def entities
      entities = [] of Entity
      entities << self
      entities
    end

    def actionable?
      false
    end

    def action(_entity : Entity)
    end

    def actionable_condition?(entity : Entity)
      trigger_facing?(entity)
    end

    def liftable?
      false
    end

    def light_source?
      false
    end

    def light_radius
      0
    end

    def light_shadow_extension
      0
    end

    def update_visibility(visibilities : Array(Visibility))
      return unless light_source?

      visibilities.reject(&.visible?).each { |v| update_visibility(v) }
    end

    def update_visibility(visibility : Visibility)
      if light_radius >= 0
        radius = light_radius * Game::GRID_SIZE
        size = radius * 2 + Game::GRID_SIZE

        if visibility.collision?(x: @x - radius, y: @y - radius, width: size, height: size)
          visibility.visible!
        end
      end

      if visibility.dark?
        radius = (light_radius + light_shadow_extension) * Game::GRID_SIZE
        size = radius * 2 + Game::GRID_SIZE

        if visibility.collision?(x: @x - radius, y: @y - radius, width: size, height: size)
          visibility.shadow!
        end
      end
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
