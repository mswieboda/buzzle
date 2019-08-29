module Buzzle
  enum Direction
    Up
    Left
    Down
    Right

    def up?
      self == Up
    end

    def left?
      self == Left
    end

    def down?
      self == Down
    end

    def right?
      self == Right
    end

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
  end
end
