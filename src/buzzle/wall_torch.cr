module Buzzle
  class WallTorch < Switch
    FPS = 12

    VISIBLITY_RADIUS = 0
    SHADOW_RADIUS    = 1

    def initialize(x, y, z = 0, on = false)
      super(
        name: "torch",
        x: x,
        y: y,
        z: z,
        on: on
      )

      puts "WallTorch switching?: #{switching?} on?: #{on?} ft: #{@frame_t} #{sprite.frames}"
    end

    def action(_entity : Entity)
      @frame_t = (@sprite.frames - 1).to_f32 / FPS if on?
      puts "WallTorch#action ft: #{@frame_t}"
      switch
    end

    def set_visibility(entity)
      return unless on?

      if entity.visibility.hidden?
        radius = SHADOW_RADIUS * Game::GRID_SIZE

        if entity.collision?(x: @x - radius, y: @y - radius, width: radius * 2 + Game::GRID_SIZE, height: radius * 2 + Game::GRID_SIZE)
          entity.visibility = Visibility::Shadow
        end
      end

      if entity.visibility.hidden? || entity.visibility.shadow?
        radius = VISIBLITY_RADIUS * Game::GRID_SIZE

        if entity.collision?(x: @x - radius, y: @y - radius, width: radius * 2 + Game::GRID_SIZE, height: radius * 2 + Game::GRID_SIZE)
          entity.visibility = Visibility::Visible
        end
      end
    end

    def frame
      return (@frame_t * FPS).to_i if switching?
      off? ? 0 : sprite.frames - 1
    end

    def update(frame_time, entities : Array(Entity))
      super

      entities.each { |e| set_visibility(e) } if on?
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        row: 2,
        frame: frame
      )
    end
  end
end
