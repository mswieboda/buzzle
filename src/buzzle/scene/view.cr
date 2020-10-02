require "../view"
require "../room/base"

module Buzzle::Scene
  class View < Buzzle::View
    getter player : Player
    property room : Room::Base

    THRESHOLD = 1.5_f32

    def initialize(@player, @room)
      width = (Game::SCREEN_WIDTH / 2).to_i
      height = (Game::SCREEN_HEIGHT / 2).to_i
      super(
        x: (Game::SCREEN_WIDTH / 2 - width / 2).to_i,
        y: (Game::SCREEN_HEIGHT / 2 - height / 2).to_i,
        width: width,
        height: height
      )
    end

    def update(frame_time)
      # TODO: this should grab movement speed from player directly
      movement = Being::MOVING_AMOUNT

      if player.x - room.x <= Game::GRID_SIZE * THRESHOLD && room.x - movement >= 0 - Game::GRID_SIZE
        @room.x -= movement
      end

      if room.x + width - player.x <= Game::GRID_SIZE * THRESHOLD && room.x + width + movement <= room.width + Game::GRID_SIZE
        @room.x += movement
      end

      if player.y - room.y <= Game::GRID_SIZE * THRESHOLD && room.y - movement >= 0 - Game::GRID_SIZE
        @room.y -= movement
      end

      if room.y + height - player.y <= Game::GRID_SIZE * THRESHOLD && room.y + height + movement <= room.height + Game::GRID_SIZE
        @room.y += movement
      end
    end

    # draws border around view to smooth view movement
    def draw
      border = Game::GRID_SIZE * THRESHOLD

      # left
      Rectangle.new(x: x - border, y: y, width: border, height: height, color: Color::Black).draw

      # right
      Rectangle.new(x: x + width, y: y, width: border, height: height, color: Color::Black).draw

      # top
      Rectangle.new(x: x - border, y: y - border, width: width + border * 2, height: border, color: Color::Black).draw

      # bottom
      Rectangle.new(x: x - border, y: y + height, width: width + border * 2, height: border, color: Color::Black).draw
    end

    def viewable?(obj : Obj)
      viewable?(
        obj: obj,
        view_x: room.x,
        view_y: room.y
      )
    end

    def screen_x
      x - room.x
    end

    def screen_y
      y - room.y
    end
  end
end
