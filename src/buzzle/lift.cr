module Buzzle
  class Lift < Floor
    getter? enabled
    getter? ascend

    MOVING_AMOUNT = 2

    def initialize(x, y, z = 0, @ascend = true)
      super(
        name: "lift",
        x: x,
        y: y,
        z: ascend? ? z : z + 1
      )

      @moving = 0.0
      @enabled = true

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

    def lift(players : Array(Player), amount)
      @y += amount

      players.each do |player|
        player.lift(amount)
        player.ascend if ascend? && @moving == 0
      end

      ascend if ascend? && @moving == 0

      @moving += amount

      if @moving.abs > Game::GRID_SIZE
        @moving -= amount
        @y -= amount

        players.each do |player|
          player.lift(-amount)
          player.lift_stopped

          if descend?
            player.descend
          end
        end

        descend if descend?

        switch
      end
    end

    def ascend
      @z += 1
    end

    def descend
      @z -= 1
    end

    def switch
      @ascend = !@ascend
      @moving = 0
      disable
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
        lift(players, ascend? ? -MOVING_AMOUNT : MOVING_AMOUNT)
      elsif disabled? && players.empty?
        enable
      end
    end

    def draw(screen_x, screen_y)
      draw_partial(
        screen_x: screen_x,
        screen_y: screen_y,
        source_height: ascend? ? Game::GRID_SIZE + @moving.abs : Game::GRID_SIZE * 2 - @moving.abs,
        y: y
      )
    end
  end
end
