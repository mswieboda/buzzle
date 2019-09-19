module Buzzle::Door
  class Locked < Base
    getter? locked

    def initialize(x, y, z = 0, direction = Direction::Down, design = Design::Locked, open = false, @locked = true)
      super(
        x: x,
        y: y,
        z: z,
        direction: direction,
        design: design,
        open: open
      )
    end

    def unlocked?
      !locked?
    end

    def unlock
      @locked = false
    end

    def actionable_condition?(entity : Entity)
      return false unless entity.is_a?(Player)

      player = entity.as(Player)

      return false if closed? && locked? && !player.use_item?(Item::Key)

      trigger_facing?(player)
    end

    def actionable?
      true
    end

    def action(_entity : Entity)
      unlock if closed? && locked?

      toggle
    end
  end
end
