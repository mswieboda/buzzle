module Buzzle
  class Message
    getter? shown

    @text_color : LibRay::Color

    MARGIN = 13
    MIN_DELAY = 1

    @@message = Message.new

    def self.init
      @@message = Message.new
    end

    def self.message
      @@message
    end

    def self.show(message, pause = true)
      @@message.show(message, pause)
    end

    def initialize(@messages = [] of String)
      @message_index = 0
      @shown = false
      @delay = 0_f32

      @default_font = LibRay.get_font_default
      @text = @messages.any? ? @messages[@message_index] : ""
      @text_font_size = 33
      @text_spacing = 5
      @text_color = LibRay::WHITE
      @text_measured = LibRay.measure_text_ex(
        font: @default_font,
        text: @text,
        font_size: @text_font_size,
        spacing: @text_spacing
      )
    end

    def update(frame_time)
      return unless shown?

      @delay += frame_time

      return if delay?

      if Keys.pressed?([LibRay::KEY_LEFT_SHIFT, LibRay::KEY_RIGHT_SHIFT])
        @message_index += 1

        if @message_index >= @messages.size
          hide
        else
          @delay = 0
          @text = @messages[@message_index]
          update_text_measured
        end
      end
    end

    def draw
      return unless shown?

      x = MARGIN * 2
      y = Game::SCREEN_HEIGHT - @text_measured.y - MARGIN * 2

      LibRay.draw_text_ex(
        font: @default_font,
        text: @text,
        position: LibRay::Vector2.new(
          x: x,
          y: y
        ),
        font_size: @text_font_size,
        spacing: @text_spacing,
        tint: @text_color
      )
    end

    def update_text_measured
      @text_measured = LibRay.measure_text_ex(
        font: @default_font,
        text: @text,
        font_size: @text_font_size,
        spacing: @text_spacing
      )
    end

    def show(messages, pause = true)
      @message_index = 0
      @messages = messages
      @text = @messages.any? ? @messages[@message_index] : ""
      @text_measured = LibRay.measure_text_ex(
        font: @default_font,
        text: @text,
        font_size: @text_font_size,
        spacing: @text_spacing
      )
      Game.pause_player_input = true if pause
      @shown = true
    end

    def hide
      @shown = false
      @message_index = 0
      @messages = [] of String
      @text = ""
      update_text_measured
      Game.pause_player_input = false
    end

    def delay?
      @delay < MIN_DELAY
    end
  end
end
