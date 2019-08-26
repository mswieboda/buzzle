module Buzzle
  enum Direction
    Up
    Left
    Down
    Right

    def opposite?(other_direction)
      case self
      when Up
        other_direction == Down
      when Left
        other_direction == Right
      when Down
        other_direction == Up
      when Right
        other_direction == Left
      else
        false
      end
    end
  end
end
