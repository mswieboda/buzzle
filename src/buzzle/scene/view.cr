require "../view"
require "../room/base"

module Buzzle::Scene
  class View < Buzzle::View
    getter player : Player
    getter room : Room::Base

    EDGE_VIEWABILITY = Game::GRID_SIZE * 1
    VIEW_THRESHOLD = Game::GRID_SIZE * 3
    BORDER_HIDE = Game::GRID_SIZE * 2

    def initialize(@player, @room)
      super(
        x: 0,
        y: 0,
        width: Game.screen_width,
        height: Game.screen_height
      )
    end

    def room=(room : Room::Base)
      @room = room

      if room.width < width
        @x = ((width - room.width) / 2).to_i
      end

      if room.height < height
        @y = ((height - room.height) / 2).to_i
      end
    end

    def update(frame_time)
      movement(frame_time)
    end

    # draws border around view to smooth view movement
    def draw
      border = BORDER_HIDE

      # left
      Rectangle.new(x: x - border, y: y, width: border, height: height, color: Color::Black).draw

      # right
      Rectangle.new(x: x + width, y: y, width: border, height: height, color: Color::Black).draw

      # top
      Rectangle.new(x: x - border, y: y - border, width: width + border * 2, height: border, color: Color::Black).draw

      # bottom
      Rectangle.new(x: x - border, y: y + height, width: width + border * 2, height: border, color: Color::Black).draw
    end

    def movement(frame_time)
      return if room.width < width && room.height < height

      # TODO: this should grab movement speed from player directly
      movement = Being::MOVING_AMOUNT

      if player.x - room.x <= VIEW_THRESHOLD && room.x - movement >= 0 - EDGE_VIEWABILITY
        @room.x -= movement
      elsif room.x + width - player.x <= VIEW_THRESHOLD && room.x + width + movement <= room.width + EDGE_VIEWABILITY
        @room.x += movement
      elsif player.y - room.y <= VIEW_THRESHOLD && room.y - movement >= 0 - EDGE_VIEWABILITY
        @room.y -= movement
      elsif room.y + height - player.y <= VIEW_THRESHOLD && room.y + height + movement <= room.height + EDGE_VIEWABILITY
        @room.y += movement
      end
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
