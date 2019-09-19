module Buzzle::Floor
  class River < Base
    DROP_MOVEMENT = 1

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

      @accent = Accent.new(
        x: x,
        y: y,
        z: z,
        direction: direction,
        design: Accent::Design::River
      )

      @accent.try(&.randomize_origin)

      @drop_blocks = [] of Block
      @drop_block_movement = 0

      @bridge_floor = Base.new(x: x, y: y, z: z - 1, hidden: true)
    end

    def entities
      super + [@bridge_floor]
    end

    def traversable?
      false
    end

    def block_slide?
      true
    end

    def bridge?
      @bridge_floor.z > z
    end

    def trigger?(entity : Entity)
      @triggers.all? { |t| t.trigger?(entity) }
    end

    def update(frame_time, entities)
      super

      @triggers.each(&.update(self))

      unless bridge? || @drop_blocks.any?
        @drop_blocks = entities.select(&.is_a?(Block)).select { |e| trigger?(e) }.map(&.as(Block))
      end

      @drop_blocks.each do |block|
        block.lift(DROP_MOVEMENT)
        @drop_block_movement += DROP_MOVEMENT
        block.source_height = block.height - 4 - @drop_block_movement

        if @drop_block_movement >= Game::GRID_SIZE / 4
          @bridge_floor.ascend
          block.descend
          descend
          @accent.try(&.descend)

          @drop_blocks.clear
          @drop_block_movement = 0
        end
      end
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 0,
        tint: LibRay::BLUE
      )
    end
  end
end
