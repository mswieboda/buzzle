module Buzzle
  class Friendly < Character
    @messages : Array(Array(String))

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

      @messages_index = 0
    end

    def actionable?
      true
    end

    def action(player : Player)
      orig_dir = direction

      face(player)

      Message.show(@messages[@messages_index]) do
        @direction = orig_dir
        @messages_index += 1 unless @messages_index == @messages.size - 1
      end
    end
  end
end
