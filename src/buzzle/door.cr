require "./switch"

module Buzzle
  class Door < Switch
    getter players_entered

    def initialize(x, y, closed = true)
      super(x, y, "door", !closed, Game::GRID_SIZE, Game::GRID_SIZE)

      @players_entered = [] of Player
      @trigger = Trigger.new(x, y, Game::GRID_SIZE)
    end

    def trigger?(entity : Entity)
      open? && @trigger.collision?(entity)
    end

    def toggle
      switch
    end

    def closed?
      off?
    end

    def open?
      on?
    end

    def open
      toggle if closed?
    end

    def close
      toggle if open?
    end

    def collidable?
      closed?
    end

    def player_left(player : Player)
      @players_entered.delete(player)
    end
  end
end
