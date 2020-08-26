module Buzzle
  class Npc < Character
    def initialize
      super

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
      puts ">>> talked to NPC"
    end
  end
end
