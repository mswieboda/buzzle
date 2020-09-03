module Buzzle
  class QuestAction
    property quest : String
    property step : String
    property messages : Array(String)

    @character : Character?
    @before : Proc(Nil)
    @after : Proc(Nil)

    def initialize(@quest, @step, @messages = [] of String, @character = nil, @before = ->() {}, @after = ->() {})
    end

    def action(player : Player)
      @before.call

      if messages.any?
        message do
          @after.call
          Quest.do(quest, step)
        end
      else
        @after.call
        Quest.do(quest, step)
      end
    end

    def message(&block)
      if @character
        Message.show(@character.as(Entity), messages) do
          block.call
        end
      else
        Message.show(messages) do
          block.call
        end
      end
    end
  end
end
