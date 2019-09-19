module Buzzle
  class HeadsUpDisplay
    @keys_sprite : Sprite
    @keys_text_color : LibRay::Color

    KEYS_MARGIN = 8

    def initialize(@player : Player)
      @default_font = LibRay.get_default_font

      @keys_text = "0"
      @keys_sprite = Sprite.get("key")
      @keys_text_font_size = 10
      @keys_text_spacing = 3
      @keys_text_color = LibRay::WHITE
      @keys_text_measured = LibRay.measure_text_ex(
        sprite_font: @default_font,
        text: @keys_text,
        font_size: @keys_text_font_size,
        spacing: @keys_text_spacing
      )
    end

    def update(_frame_time)
      @keys_text = @player.items.count(&.is_a?(Item::Key)).to_s
      @keys_text_measured = LibRay.measure_text_ex(
        sprite_font: @default_font,
        text: @keys_text,
        font_size: @keys_text_font_size,
        spacing: @keys_text_spacing
      )
    end

    def draw
      draw_keys
    end

    def draw_keys
      x = KEYS_MARGIN * 2
      y = KEYS_MARGIN * 2

      LibRay.draw_text_ex(
        sprite_font: @default_font,
        text: @keys_text,
        position: LibRay::Vector2.new(
          x: x,
          y: y
        ),
        font_size: @keys_text_font_size,
        spacing: @keys_text_spacing,
        color: @keys_text_color
      )

      @keys_sprite.draw(
        x: x + @keys_text_measured.x + KEYS_MARGIN,
        y: y + @keys_text_measured.y / 2 - @keys_sprite.height / 2
      )
    end
  end
end
