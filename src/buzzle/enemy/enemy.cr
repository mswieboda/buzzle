module Buzzle
  abstract class Enemy < Being
    FPS = 12

    def initialize(sprite, x = 0, y = 0, z = 0, direction = Direction::Down, tint : Color = Color::White)
      super(
        sprite: sprite,
        x: x,
        y: y,
        z: z,
        direction: direction,
        tint: tint
      )

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: (-width / 2).to_i,
        origin_y: (-height / 2).to_i,
        width: width * 2,
        height: height * 2
      )

      @moving_left_foot = false
      @frame_t = 0_f32
      @dead = false
    end

    def update(frame_time, entities : Array(Entity))
      super

      movement(frame_time, entities)
    end

    def frame
      if moving?
        @moving_left_foot ? 1 : 2
      else
        0
      end
    end

    def frame=(frame)
      @frame_t = frame.to_f32 / fps
    end

    def fps
      FPS
    end

    def row
      direction.to_i
    end

    def actionable?
      true
    end

    def action(player : Player)
      face(player)

      fight = Fight.new(initiator: player, other: self)
      player.fight = fight
      @fight = fight
      fight.start
    end
  end
end
