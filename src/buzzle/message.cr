module Buzzle
  class Message
    getter? shown

    @character : Character?
    @text_color : LibRay::Color

    MARGIN = 13
    BORDER_SIZE = 3
    PADDING = 13
    MIN_DELAY = 0.5

    @@message = Message.new

    def self.init
      @@message = Message.new
    end

    def self.message
      @@message
    end

    def self.show(messages : Array(String), pause = true)
      @@message.show(messages, pause)
    end

    def self.show(messages : Array(String), pause = true, &block)
      @@on_hide_callback = block
      show(messages, pause)
    end

    def self.show(character : Character, messages : Array(String), pause = true)
      @@message.show(character, messages, pause)
    end

    def self.show(character : Character, messages : Array(String), pause = true, &block)
      @@on_hide_callback = block
      show(character, messages, pause)
    end

    def initialize(@character = nil, @messages = [] of String)
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

      draw_border

      if character = @character
        draw(character)
      else
        draw_message
      end
    end

    def draw_border
      width = Game::SCREEN_WIDTH - MARGIN * 2
      height = @text_measured.y + PADDING * 2

      x = MARGIN
      y = Game::SCREEN_HEIGHT - MARGIN - BORDER_SIZE - height - BORDER_SIZE

      BORDER_SIZE.times do |n|
        Rectangle.new(
          x: x + n,
          y: y + n,
          width: width - n * 2,
          height: height + BORDER_SIZE * 2 - n * 2,
          color: Color::White,
          filled: false
        ).draw
      end
    end

    def draw(character : Character)
      measured = LibRay.measure_text_ex(
        font: @default_font,
        text: character.name,
        font_size: @text_font_size,
        spacing: @text_spacing
      )

      x = MARGIN + BORDER_SIZE + PADDING
      y = Game::SCREEN_HEIGHT - MARGIN - PADDING - measured.y

      LibRay.draw_text_ex(
        font: @default_font,
        text: character.name,
        position: LibRay::Vector2.new(
          x: x,
          y: y
        ),
        font_size: @text_font_size,
        spacing: @text_spacing,
        tint: @text_color
      )

      line_x = (x + measured.x + PADDING).to_i

      # vertical line
      BORDER_SIZE.times do |n|
        Line.new(
          start_x: line_x + n,
          start_y: (y - PADDING).to_i,
          end_x: line_x + n,
          end_y: Game::SCREEN_HEIGHT - MARGIN,
          color: Color::White
        ).draw
      end

      draw_message(x_start: line_x + BORDER_SIZE)
    end

    def draw_message(x_start = MARGIN + BORDER_SIZE)
      x = x_start + PADDING
      y = Game::SCREEN_HEIGHT - MARGIN - BORDER_SIZE - PADDING - @text_measured.y

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

      return if delay?

      x = x_start + Game::SCREEN_WIDTH - x_start - MARGIN - BORDER_SIZE - PADDING
      y = Game::SCREEN_HEIGHT - MARGIN - BORDER_SIZE - PADDING

      # temp message done icon

      # outer
      rect = Square.new(size: 30, color: Color::White, filled: false)
      rect.x = x - rect.width
      rect.y = y - rect.height
      rect.draw

      # inner
      rect = Square.new(size: 10, color: Color::White)
      rect.x = x - rect.width - 10
      rect.y = y - rect.height - 10
      rect.draw
    end

    def update_text_measured
      @text_measured = LibRay.measure_text_ex(
        font: @default_font,
        text: @text,
        font_size: @text_font_size,
        spacing: @text_spacing
      )
    end

    def show(character : Character, messages : Array(String), pause = true)
      @character = character
      show(messages, pause)
    end

    def show(messages : Array(String), pause = true)
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
      @delay = 0_f32
      update_text_measured
      Game.pause_player_input = false

      if callback = @@on_hide_callback
        callback.call
      end
    end

    def delay?
      @delay < MIN_DELAY
    end
  end
end
