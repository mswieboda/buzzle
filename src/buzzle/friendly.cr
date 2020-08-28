module Buzzle
  class Friendly < Character
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
      orig_dir = direction

      face(player)

      Message.show(@messages) do
        @direction = orig_dir
      end
    end
  end
end
