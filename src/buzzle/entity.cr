module Buzzle
  class Entity < Obj
    def initialize(x : Int32 | Float32, y : Int32 | Float32, z = 0, width = 0, height = 0, direction = Direction::Down, hidden = false)
      super
      @trigger = Trigger.new(enabled: false)
    end

    def facing?(player : Player, opposite = false)
      direction = opposite ? player.direction.opposite : player.direction

      if player.x < x
        player.y == y && direction.right?
      elsif player.x > x
        player.y == y && direction.left?
      else
        if player.y < y
          direction.down?
        elsif player.y > y
          direction.up?
        else
          # player is standing on (x, y)
          true
        end
      end
    end

    def trigger?(entity : Entity)
      @trigger.trigger?(entity)
    end

    def trigger_facing?(player : Player, opposite = false)
      trigger?(player) && facing?(player, opposite)
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
