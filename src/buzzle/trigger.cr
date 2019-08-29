module Buzzle
  class Trigger < Obj
    getter? enabled

    def initialize(x = 0, y = 0, z = 1, @origin_x = 0, @origin_y = 0, width = 1, height = 1, @enabled = true)
      super(
        x: x + @origin_x,
        y: y + @origin_y,
        z: z,
        width: width,
        height: height
      )
    end

    def trigger?(entity : Entity)
      collision?(entity)
    end

    def update(this_entity : Entity)
      @x = this_entity.x + @origin_x
      @y = this_entity.y + @origin_y
    end

    def draw
      LibRay.draw_rectangle_lines(
        pos_x: x,
        pos_y: y,
        width: width,
        height: height,
        color: LibRay::MAGENTA
      )
    end
  end
end
