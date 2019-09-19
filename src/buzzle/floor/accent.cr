module Buzzle::Floor
  class Accent < SpriteEntity
    FPS = 24

    ANIMATION_DELAY_TIMER = 5
    ANIMATION_DELAY_MIN   = 1

    enum Design
      Floor
      Grass
      River

      def variations
        case self
        when .floor?
          32
        when .grass?
          32
        when .river?
          32
        else
          0
        end
      end
    end

    def initialize(x, y, z = 0, direction = Direction::Down, @design = Design::Floor, @variation = -1)
      super(
        name: "accents",
        x: x,
        y: y,
        z: z,
        direction: direction
      )

      @width = sprite.width
      @height = sprite.height

      @variation = rand(@design.variations) if @variation < 0

      @frame_t = 0_f32
      @frame_t = @variation.to_f32 / FPS if @design.river?
      @animation_delay_timer = Timer.new(ANIMATION_DELAY_TIMER)
    end

    def layer
      1
    end

    def collidable?
      false
    end

    def randomize_origin
      @x += rand(Game::GRID_SIZE - sprite.width)
      @y += rand(Game::GRID_SIZE - sprite.height)
    end

    def update(frame_time)
      return unless @design.river?

      if @frame_t == 0 && @animation_delay_timer.progressing?
        @animation_delay_timer.increase(frame_time)
        return
      end

      if @animation_delay_timer.done?
        show
        @animation_delay_timer.reset
      end

      @frame_t += frame_time

      if frame >= @design.variations
        hide
        @frame_t = 0
        start_time = ANIMATION_DELAY_MIN + rand((ANIMATION_DELAY_TIMER - ANIMATION_DELAY_MIN).to_f32).to_f32
        @animation_delay_timer.restart(start_time: start_time)
      end
    end

    def frame
      (@frame_t * FPS).to_i
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        center_x: false,
        center_y: false,
        frame: @design.river? ? frame : @variation,
        row: @design.to_i
      )
    end
  end
end
