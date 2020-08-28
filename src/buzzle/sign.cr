module Buzzle
  class Sign < SpriteEntity
    property messages : Array(String)

    def initialize(x, y, z = 0, @messages = [] of String)
      super(
        sprite: "sign",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
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
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        center_y: false,
        x: x,
        y: y
      )
    end

    def actionable?
      true
    end

    def action(_entity : Entity)
      Message.show(messages)
    end
  end
end
