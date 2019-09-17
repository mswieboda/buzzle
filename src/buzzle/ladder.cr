module Buzzle
  class Ladder < Floor
    def initialize(x, y, z = 0, @ascend = true)
      super(
        name: "wall",
        x: x,
        y: y,
        z: z
      )

      @trigger = Trigger.new(
        z: @ascend ? 0 : 1,
        origin_x: 0,
        origin_y: @ascend ? -1 : height - 1,
        width: width,
        height: 1
      )
    end

    def layer
      2
    end

    def draw(screen_x, screen_y)
      return unless @ascend

      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 1
      )
    end

    def update(_frame_time, entities)
      super

      players = entities.select(&.is_a?(Player)).map(&.as(Player))
      # TODO: fix ladder `trigger_facing?(p, opposite: @ascend)` issues
      players.select { |p| trigger?(p) }.each do |player|
        @ascend ? player.ascend : player.descend
      end
    end
  end
end
