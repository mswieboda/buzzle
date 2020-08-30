module Buzzle
  class Quest
    STEP_DONE = "_DONE_"

    @@quest = Quest.new

    @quests : Hash(String, String)

    def self.quest
      @@quest
    end

    def self.do(quest, step)
      @@quest.do(quest, step)
    end

    def self.started?(quest)
      @@quest.started?(quest)
    end

    def self.unstarted?(quest)
      @@quest.unstarted?(quest)
    end

    def self.done?(quest, step = STEP_DONE)
      @@quest.done?(quest, step)
    end

    def self.step(quest)
      @@quest.step(quest)
    end

    def initialize
      @quests = {} of String => String
    end

    def do(quest, step)
      @quests[quest] = step
    end

    def started?(quest)
      @quests.has_key?(quest)
    end

    def unstarted?(quest)
      !started?(quest)
    end

    def done?(quest, step = STEP_DONE)
      started?(quest) && step(quest) == step
    end

    def step(quest)
      @quests[quest]
    end
  end
end
