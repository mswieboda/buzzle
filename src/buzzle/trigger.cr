module Buzzle
  class Trigger < Entity
    def initialize(x, y, @origin_x = 0, @origin_y = 0, width = 1, height = 1)
      super(x + @origin_x, y + @origin_y, width, height)
    end

    def trigger?(this_entity : Entity, entity : Entity)
      @x = this_entity.x + @origin_x
      @y = this_entity.y + @origin_y

      collision?(entity)
    end
  end
end
