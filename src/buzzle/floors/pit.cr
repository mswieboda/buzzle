module Buzzle::Floors
  class Pit < Floor
    DROP_MOVEMENT = 2

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

      @drop_blocks = [] of Block
      @drop_block_movement = 0
    end

    def layer
      1
    end

    def block_slide?
      true
    end

    def trigger?(entity : Entity)
      @triggers.all? { |t| t.trigger?(entity) }
    end

    def update(_frame_time, entities)
      super

      @triggers.each(&.update(self))

      players = entities.select(&.is_a?(Player)).map(&.as(Player)).reject { |p| p.falling? || p.dead? }
      players.select { |p| trigger?(p) }.each(&.fall)

      unless @drop_blocks.any?
        @drop_blocks = entities.select(&.is_a?(Block)).select { |e| trigger?(e) }.map(&.as(Block))
      end

      @drop_blocks.each do |block|
        block.lift(DROP_MOVEMENT)
        @drop_block_movement += DROP_MOVEMENT
        block.source_height = block.height - @drop_block_movement

        if @drop_block_movement >= Game::GRID_SIZE
          block.stop
          block.lift_stopped
          block.source_height = nil
          block.die
          @drop_blocks.clear
          @drop_block_movement = 0
        end
      end
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
