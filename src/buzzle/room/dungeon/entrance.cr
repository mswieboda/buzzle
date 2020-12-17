module Buzzle::Room::Dungeon
  class Entrance < Room::Base
    def initialize(player, width = 50, height = 30)
      entities = [] of Entity
      entities << player

      # character --- start
      char = Character.new(
        sprite: "player",
        name: "Matt",
        messages: [["default message..."]],
        tint: Color::Violet
      )

      char.quest_actions = [
        QuestAction.new(
          quest: "welcome",
          step: "hey",
          messages: ["hey...", "what's up?"],
          character: char,
          before: ->() { char.face(player) },
          after: ->() { char.move_to(1, 3) }
        ),
        QuestAction.new(
          quest: "welcome",
          step: "river",
          messages: ["did you need something?"],
          character: char,
          before: ->() do
            char.direction_temp = char.direction
            char.face(player)
          end,
          after: ->() do
            char.direction = char.direction_temp
          end
        )
      ]

      char.initial_location(x: 3, y: 8)
      char.face(Direction::Left)

      entities << char
      # character --- end

      doors = {
        :dark => Door::Gate.new(3, -1, open: false).as(Door::Base),
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
      entities << Sign.new(x: 5, y: 5, messages: ["warning!", "a creepy dungeon lies ahead..."])

      # enemies
      enemy = Enemy.new(
        sprite: "player",
        tint: Color::Red
      )
      enemy.initial_location(x: 13, y: 7)
      enemy.face(Direction::Right)
      entities << enemy

      super(
        player: player,
        entities: entities,
        doors: doors,
        width: width,
        height: height
      )

      add_top_walls
    end

    def update(_frame_time)
      super

      if quest_step?("welcome", "hey")
        puts "hey done!"
        # raise gate
        doors[:dark].open
      end

      if quest_step?("welcome", "river")
        puts "river done!"
        # do something crazy?
      end
    end
  end
end
