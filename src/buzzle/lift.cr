module Buzzle
  class Lift < Floor
    getter? enabled
    getter? ascend
    getter? lowering
    getter? raising
    getter? auto

    MOVING_AMOUNT = 2

    def initialize(x, y, z = 0, @ascend = true, @auto = true)
      super(
        name: "floor",
        x: x,
        y: y,
        z: ascend? ? z : z + 1
      )

      @moving = 0
      @enabled = auto?
      @lowering = @raising = false

      @triggers = [] of Trigger
      @triggers << Trigger.new(
        origin_x: 0,
        origin_y: 0,
        width: Game::GRID_SIZE,
        height: 1
      )
      @triggers << Trigger.new(
        origin_x: Game::GRID_SIZE - 1,
        origin_y: 0,
        width: 1,
        height: Game::GRID_SIZE
      )
      @triggers << Trigger.new(
        origin_x: 0,
        origin_y: Game::GRID_SIZE - 1,
        width: Game::GRID_SIZE,
        height: 1
      )
      @triggers << Trigger.new(
        origin_x: 0,
        origin_y: 0,
        width: 1,
        height: Game::GRID_SIZE
      )

      @walls = [] of Wall
      @walls << Wall.new(x, y + 1, z, direction: Direction::Up, hidden: true)
      @walls << Wall.new(x, y, z, direction: Direction::Down)

      @walls.each do |wall|
        if ascend?
          wall.disable
          wall.source_height = @moving.abs
        else
          wall.enable
          wall.source_height = wall.height - @moving.abs
        end
      end
    end

    def entities
      [self] + @walls
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

    def moving?
      @moving != 0
    end

    def lift(entities : Array(Entity), amount)
      @y += amount
      @walls.each(&.lift(amount))

      entities.each do |entity|
        entity.lift(amount)

        if ascend? && @moving == 0
          entity.lift_stopped
          entity.ascend
        end
      end

      ascend if ascend? && @moving == 0

      @moving += amount

      if @moving.abs > Game::GRID_SIZE
        @moving -= amount
        @y -= amount
        @walls.each(&.lift(-amount))

        entities.each do |entity|
          entity.lift(-amount)

          if descend?
            entity.lift_stopped
            entity.descend
          end
        end

        descend if descend?

        switch
      end

      @walls.each do |wall|
        wall.source_height = ascend? ? @moving.abs : wall.height - @moving.abs
      end
    end

    def ascend
      @z += 1

      @walls.each(&.enable)
    end

    def descend
      @z -= 1

      @walls.each(&.disable)
    end

    def switch
      @ascend = !@ascend
      @moving = 0
      @lowering = @raising = false
      disable
    end

    def lower
      return if ascend? || lowering? || raising?

      enable unless auto?
      @raising = false
      @lowering = true
    end

    def raise
      return if descend? || lowering? || raising?

      enable unless auto?
      @lowering = false
      @raising = true
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

      if enabled?
        liftables = [] of Entity

        if !lowering? && !raising?
          liftables = entities.select { |e| e.liftable? && trigger?(e) }

          return if auto? && liftables.empty?
        end

        lift(liftables, ascend? ? -MOVING_AMOUNT : MOVING_AMOUNT)
      else
        if auto?
          liftables = entities.select { |e| e.liftable? && @triggers.any? { |t| t.trigger?(e) } }
          enable if liftables.empty?
        end
      end
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 2
      )
    end
  end
end
