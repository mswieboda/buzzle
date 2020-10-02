module Buzzle::Room
  class Dark < Base
    def initialize(@player, entities = [] of Entity, doors = Hash(Symbol, Door::Base).new, width = 10, height = 10)
      super

      @visibilities = [] of Visibility

      (-1..width + 1).to_a.each do |x|
        (-1..height + 1).to_a.each do |y|
          @visibilities << Visibility.new(x, y)
        end
      end
    end

    def update(frame_time)
      super

      @visibilities.each(&.dark!)
      @entities.select(&.light_source?).each(&.update_visibility(@visibilities))
    end

    def draw(view : Scene::View)
      super(view)

      @visibilities.each(&.draw(view.screen_x, view.screen_y))
    end
  end
end
