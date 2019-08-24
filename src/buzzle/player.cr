module Buzzle
  class Player < SpriteEntity
    getter direction : Direction

    WIDTH  = Game::GRID_SIZE
    HEIGHT = Game::GRID_SIZE

    DRAW_SIZE_PADDING = 12

    def initialize(x, y, @direction = Direction::Up)
      super("player", x, y, WIDTH, HEIGHT)
    end

    def update(frame_time, entities : Array(Entity))
      move(frame_time, entities)
    end

    def move(frame_time, entities)
      if Keys.pressed?([LibRay::KEY_W, LibRay::KEY_UP])
        @y -= 1
        @direction = Direction::Up
      end

      if Keys.pressed?([LibRay::KEY_A, LibRay::KEY_LEFT])
        @x -= 1
        @direction = Direction::Left
      end

      if Keys.pressed?([LibRay::KEY_S, LibRay::KEY_DOWN])
        @y += 1
        @direction = Direction::Down
      end

      if Keys.pressed?([LibRay::KEY_D, LibRay::KEY_RIGHT])
        @x += 1
        @direction = Direction::Right
      end

      # TODO: collisions with entities
    end

    def draw
      draw(row: direction.to_i)
    end

    def action_cell
      case direction
      when Direction::Up
        [x, y - 1]
      when Direction::Left
        [x - 1, y]
      when Direction::Down
        [x, y + 1]
      when Direction::Right
        [x + 1, y]
      else
        [x, y]
      end
    end
  end
end
