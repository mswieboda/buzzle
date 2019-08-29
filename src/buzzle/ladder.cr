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
        origin_y: @ascend ? -1 : 0,
        width: width,
        height: 1
      )
    end

    def layer
      1
    end

    def update(_frame_time, entities)
      super

      players = entities.select(&.is_a?(Player)).map(&.as(Player)).reject(&.moving?)
      players.select { |p| trigger_facing?(p, opposite: true) }.each do |player|
        @ascend ? player.ascend : player.descend
      end
    end
  end
end
