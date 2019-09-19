module Buzzle::Room
  class Dark < Base
    def initialize(@player, @entities = [] of Entity, width = 10, height = 10)
      super

      @visibilities = [] of Visibility

      width.times do |x|
        height.times do |y|
          @visibilities << Visibility.new(x, y)
        end
      end
    end

    def update(frame_time)
      super

      @visibilities.each(&.dark!)
      @entities.select(&.light_source?).each(&.update_visibility(@visibilities))
    end

    def draw
      super

      @visibilities.each(&.draw(x, y))
    end
  end
end
