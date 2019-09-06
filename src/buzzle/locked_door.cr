module Buzzle
  class LockedDoor < Door
    getter? locked

    def initialize(x, y, z = 0, open = false)
      super(
        x: x,
        y: y,
        z: z,
        open: open,
        design: Door::Type::WoodenLocked
      )

      @locked = true
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

      return false if closed? && locked? && !player.use_item?(:key)

      trigger_facing?(player)
    end

    def actionable?
      true
    end

    def action
      unlock if closed? && locked?

      toggle
    end
  end
end
