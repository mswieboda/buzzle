module Buzzle
  class Lift < Floor
    getter? enabled
    getter? ascend

    MOVING_AMOUNT = 2

    def initialize(x, y, z = 0, @ascend = true)
      super(
        name: "ladder",
        x: x,
        y: y,
        z: z
      )

      @moving = 0
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

    def collidable?
      moving?
    end

    def moving?
      @moving != 0
    end

    def stop
      @moving = 0
    end

    def ascend(players : Array(Player))
      players.each(&.lift_ascend)

      @moving -= MOVING_AMOUNT

      if @moving.abs > height
        @moving += MOVING_AMOUNT

        stop
        switch
      end
    end

    def descend(players : Array(Player))
      players.each(&.lift_descend)

      @moving += MOVING_AMOUNT

      if @moving.abs > height
        @moving -= MOVING_AMOUNT

        stop
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
        disable

        if ascend?
          ascend(players)
        elsif descend?
          descend(players)
        end
      elsif players.empty? && disabled? && !moving?
        enable
      end
    end

    def frame
      # TODO: figure out division for animation
      @moving / 16
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end
  end
end
