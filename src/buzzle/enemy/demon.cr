require "./enemy"

module Buzzle
  class Demon < Enemy
    getter? dead

    FPS = 12

    def initialize(x = 0, y = 0, z = 0, direction = Direction::Left, sprite = "player", tint : Color = Color::Red)
      super(
        x: x,
        y: y,
        z: z,
        sprite: sprite,
        direction: direction,
        tint: tint,
      )

      @moving_left_foot = false
      @frame_t = 0_f32
      @dead = false
    end

    def fps
      FPS
    end
  end
end
