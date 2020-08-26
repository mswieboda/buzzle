module Buzzle::Room::Dungeon
  class Entrance < Room::Base
    def initialize(player, width = 10, height = 10)
      entities = [] of Entity
      entities << player
      npc = Npc.new
      entities << npc

      npc.initial_location(
        x: 3 * Game::GRID_SIZE,
        y: 8 * Game::GRID_SIZE,
        z: 0
      )

      doors = {
        :dark => Door::Gate.new(3, -1, open: true).as(Door::Base),
      }

      # floors
      (0..width - 1).each do |x|
        (0..height - 1).each do |y|
          # skip if river
          next if y == 3
          entities << Floor::Grass.new(x, y)
        end
      end

      # block
      entities << Block.new(7, 7)

      # river
      (0..width - 1).each do |x|
        entities << Floor::River.new(x, 3)
      end

      # sign post
      entities << Sign.new(x: 5, y: 5, messages: ["heyyy... there!", "what's goin' on, huh?"])

      super(
        player: player,
        entities: entities,
        doors: doors,
        width: width,
        height: height
      )

      add_top_walls
    end
  end
end
