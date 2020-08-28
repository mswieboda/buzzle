module Buzzle
  class Character < Being
    property name : String
    property messages : Array(Array(String))

    def initialize(@name = "", @messages = [] of Array(String))
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

    def restart_messages
      @messages_index = 0
    end

    def action(player : Player)
      return if messages.empty?

      orig_dir = direction

      face(player)

      Message.show(messages[@messages_index]) do
        @direction = orig_dir
        @messages_index += 1 unless @messages_index == messages.size - 1
      end
    end
  end
end
