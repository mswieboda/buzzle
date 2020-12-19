module Buzzle
  class Fight
    getter? ended
    getter attacker : Being

    @initiator : Being
    @other : Being
    @damage : Int32

    def initialize(@initiator, @other)
      @attacker = @initiator
      @damage = 0
    end

    def start
      @damage = @attacker.initiate_attack(defender)
    end

    def end
      @ended = true
      @initiator.end_fight
      @other.end_fight
    end

    def update(_frame_time)
      return if ended? || @attacker.attacking?

      defender.take_damage(@damage)

      @attacker = defender

      @damage = @attacker.initiate_attack(defender)
    end

    def defender
      @attacker == @initiator ? @other : @initiator
    end
  end
end
