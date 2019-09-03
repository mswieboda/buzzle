module Buzzle
  class PressureSwitch < Switch
    getter? switched

    def initialize(x, y, z = 0, on = false)
      super(
        name: "floor",
        x: x,
        y: y,
        z: z,
        on: on
      )

      @sound_done = Sound.get("pressure switch")

      @switched = false

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

    def actionable?
      false
    end

    def collidable?
      false
    end

    def update(_frame_time, entities)
      super

      @triggers.each(&.update(self))

      entities = collisions(entities.select(&.collidable?))

      if entities.empty?
        off unless off?
      elsif entities.any? { |e| trigger?(e) }
        if off? && !switching?
          on unless on?
        end
      end
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: off? ? 0 : 1,
        row: 1
      )
    end
  end
end
