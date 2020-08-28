module Buzzle
  class Character < Being
    property name : String
    property messages : Array(Array(String))

    def initialize(sprite = "player", @name = "", @messages = [] of Array(String))
      super(sprite: sprite)

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

      if name.empty?
        Message.show(messages[@messages_index]) { message_done(orig_dir) }
      else
        Message.show(self, messages[@messages_index]) { message_done(orig_dir) }
      end
    end

    def message_done(orig_dir)
      @direction = orig_dir
      @messages_index += 1 unless @messages_index == messages.size - 1
    end
  end
end
