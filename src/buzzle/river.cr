module Buzzle
  class River < Floor
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

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 0,
        row: 0,
        tint: LibRay::BLUE
      )
    end

    def trigger?(entity : Entity)
      @triggers.all? { |t| t.trigger?(entity) }
    end

    def update(frame_time, entities)
      super

      @triggers.each(&.update(self))

      players = entities.select(&.is_a?(Player)).select { |e| trigger?(e) }.map(&.as(Player)).select { |p| !p.moving? }

      players.each do |player|
        # auto move player
        # player.auto_move(dx: 1)
      end
    end
  end
end
