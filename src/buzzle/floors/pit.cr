module Buzzle::Floors
  class Pit < Floor
    def initialize(x, y, z = 0)
      super(
        x: x,
        y: y,
        z: z
      )

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

      @accent = nil
    end

    def layer
      1
    end

    def trigger?(entity : Entity)
      @triggers.all? { |t| t.trigger?(entity) }
    end

    def update(_frame_time, entities)
      super

      @triggers.each(&.update(self))

      players = entities.select(&.is_a?(Player)).map(&.as(Player)).reject { |p| p.falling? || p.dead? }
      players.select { |p| trigger?(p) }.each(&.fall)
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        tint: LibRay::BLACK
      )
    end
  end
end
