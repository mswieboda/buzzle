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

    def to_delta
      case self
      when Up
        [0, -1]
      when Left
        [-1, 0]
      when Down
        [0, 1]
      when Right
        [1, 0]
      else
        [0, 0]
      end
    end

    def to_rotation
      case self
      when Up
        0
      when Left
        -90
      when Down
        180
      when Right
        90
      else
        0
      end
    end
  end
end
