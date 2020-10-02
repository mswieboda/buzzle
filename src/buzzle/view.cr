module Buzzle
  class View
    getter x : Int32
    getter y : Int32
    getter width : Int32
    getter height : Int32

    def initialize(@x, @y, @width, @height, @view_x = 0, @view_y = 0)
    end

    def viewable?(obj : Obj, view_x, view_y)
      viewable?(
        x: obj.x,
        y: obj.y,
        width: obj.width,
        height: obj.height,
        view_x: view_x,
        view_y: view_y
      )
    end

    def viewable?(x, y, width, height, view_x, view_y)
      x + width >= view_x &&
        x <= view_x + @width &&
        y + height >= view_y &&
        y <= view_y + @height
    end
  end
end
