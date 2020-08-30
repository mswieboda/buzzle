module Buzzle
  class Character < Being
    property name : String
    property messages : Array(Array(String))

    def initialize(sprite = "player", @name = "", @messages = [] of Array(String), @tint = Color::White)
      super(
        sprite: sprite,
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

      @messages_index = 0
    end

    def actionable?
      true
    end

    def restart_messages
      @messages_index = 0
    end

    def message(messages = messages[@messages_index], &block)
      if name.empty?
        Message.show(messages) do
          @messages_index += 1 unless @messages_index == messages.size - 1
          block.call
        end
      else
        Message.show(self, messages) do
          @messages_index += 1 unless @messages_index == messages.size - 1
          block.call
        end
      end
    end

    def action(player : Player)
      return if messages.empty?

      orig_dir = direction

      face(player)

      if Quest.unstarted?("dungeon_entrance_test")
        message do
          @direction = orig_dir
          Quest.do("dungeon_entrance_test", "started")
          move_to(1, 3)
        end
      elsif Quest.done?("dungeon_entrance_test", "started")
        @messages = [["I'm taking a swim..."]]
        @messages_index = 0
        message do
          @direction = orig_dir
          puts "done"
        end
      end
    end
  end
end
