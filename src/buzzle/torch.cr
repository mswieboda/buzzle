module Buzzle
  class Torch < Switch
    FPS = 3

    VISIBLITY_RADIUS = 2
    SHADOW_RADIUS    = 3

    def initialize(x, y, z = 0, @bottom = false, on = false)
      super(
        name: "torch",
        x: x,
        y: y,
        z: z,
        on: on
      )

      radius = VISIBLITY_RADIUS * Game::GRID_SIZE
      rect = {x: @x - radius, y: @y - radius, width: radius * 3, height: radius * 3}
      puts rect
    end

    def action(_entity : Entity)
      switch(instant: true, sound: false)
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

    def update(frame_time, entities : Array(Entity))
      # TODO: call super for switching animation
      @trigger.update(self)

      @frame_t += frame_time

      @frame_t = 0 if frame >= sprite.frames

      entities.each { |e| set_visibility(e) }
    end

    def frame
      return 1 if off?
      2 + (@frame_t * FPS).to_i
    end

    def draw(screen_x, screen_y)
      # bottom
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: 0
      )

      # top
      draw(
        y: y - height,
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end
  end
end
