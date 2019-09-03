module Buzzle
  class Lift < Floor
    getter? enabled
    getter? ascend
    getter? moving

    MOVING_AMOUNT = 2

    def initialize(x, y, z = 0, @ascend = true)
      super(
        name: "ladder",
        x: x,
        y: y,
        z: z
      )

      @moving = false
      @moving_y = 0
      @enabled = true

      @triggers = [] of Trigger
      @triggers << Trigger.new(
        origin_x: 0,
        origin_y: 0,
        width: width,
        height: 1
      )
      @triggers << Trigger.new(
        origin_x: width - 1,
        origin_y: 0,
        width: 1,
        height: height
      )
      @triggers << Trigger.new(
        origin_x: 0,
        origin_y: height - 1,
        width: width,
        height: 1
      )
      @triggers << Trigger.new(
        origin_x: 0,
        origin_y: 0,
        width: 1,
        height: height
      )
    end

    def trigger?(entity : Entity)
      @triggers.all? { |t| t.trigger?(entity) }
    end

    def layer
      1
    end

    def descend?
      !ascend?
    end

    def ascending?
      ascend? && moving?
    end

    def descending?
      descend? && moving?
    end

    def collidable?
      ascending? || descending?
    end

    def move
      @moving = true
      disable
    end

    def stop
      @moving = false
      @moving_y = 0
    end

    def ascend
      @z += 1
    end

    def descend
      @z -= 1
    end

    def ascend(players : Array(Player))
      players.each(&.lift_ascend)

      @moving_y -= MOVING_AMOUNT
      @y -= MOVING_AMOUNT

      if @moving_y.abs > height
        @y += MOVING_AMOUNT

        stop
        ascend
        switch
      end
    end

    def descend(players : Array(Player))
      players.each(&.lift_descend)

      @moving_y += MOVING_AMOUNT
      @y += MOVING_AMOUNT

      if @moving_y.abs > height
        @y -= MOVING_AMOUNT

        stop
        descend
        switch
      end
    end

    def switch
      @ascend = !@ascend
    end

    def disable
      @enabled = false
    end

    def enable
      @enabled = true
    end

    def disabled?
      !enabled?
    end

    def update(_frame_time, entities)
      super

      @triggers.each(&.update(self))

      players = entities.select(&.is_a?(Player)).map(&.as(Player)).select { |p| trigger?(p) }

      if enabled? && players.any?
        move
      elsif players.empty? && disabled? && !moving?
        enable
      end

      if ascending?
        ascend(players)
      elsif descending?
        descend(players)
      end
    end
  end
end
