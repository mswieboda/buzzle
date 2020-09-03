module Buzzle
  class Character < Being
    property name : String
    property messages : Array(Array(String))
    property quest_actions : Array(QuestAction)
    property direction_temp : Direction
    setter direction : Direction

    def initialize(sprite = "player", @name = "", @messages = [] of Array(String), @tint = Color::White, @quest_actions = [] of QuestAction)
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
      @quest_actions_index = 0
      @direction_temp = direction
    end

    def actionable?
      true
    end

    def restart_messages
      @messages_index = 0
    end

    def message(&block)
      return if @messages.empty?

      if name.empty?
        Message.show(messages[@messages_index]) do
          block.call
        end
      else
        Message.show(self, messages[@messages_index]) do
          block.call
        end
      end

      @messages_index += 1 unless @messages_index >= messages.size - 1
    end

    def action(player : Player)
      if quest_actions.any?
        quest_actions[@quest_actions_index].action(player)
        @quest_actions_index += 1 unless @quest_actions_index >= quest_actions.size - 1
      elsif messages.any?
        @direction_temp = direction

        face(player)

        message do
          @direction = @direction_temp
        end
      end
    end
  end
end
