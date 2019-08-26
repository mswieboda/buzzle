module Buzzle
  enum Direction
    Up
    Left
    Down
    Right

    def opposite?(other_direction)
      self.opposite == other_direction
    end

    def opposite
      case self
      when Up
        Down
      when Left
        Right
      when Down
        Up
      when Right
        Left
      else
        Up
      end
    end
  end
end
