module Buzzle
  class Npc < Character
    @messages : Array(String)

    def initialize(@messages)
      super()

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

    def actionable?
      true
    end

    def action(player : Player)
      Message.show(@messages)
    end
  end
end
