module Buzzle
  class Ladder < Floor
    def initialize(x, y, z = 0, @ascend = true)
      super(
        name: "ladder",
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
      1
    end

    def draw(_screen_x, _screen_y)
      return unless @ascend
      super
    end

    def update(_frame_time, entities)
      super

      players = entities.select(&.is_a?(Player)).map(&.as(Player))
      players.select { |p| trigger_facing?(p, opposite: @ascend) }.each do |player|
        @ascend ? player.ascend : player.descend
      end
    end
  end
end
