module Buzzle
  class Chest < SpriteEntity
    getter? open
    getter? opened

    FPS                =  12
    LIFT_ITEM_TIMER    = 0.3
    LIFT_ITEM_MOVEMENT =   2
    GET_ITEM_TIMER     = 0.5

    @item : Item | Nil
    @player : Player | Nil

    def initialize(x, y, z = 0, item_class = Key)
      @player = nil
      @item = nil

      super(
        name: "chest",
        x: x,
        y: y,
        z: z,
        width: Game::GRID_SIZE,
        height: Game::GRID_SIZE
      )

      @open = false
      @frame_t = 0_f32

      @trigger = Trigger.new(
        x: x,
        y: y,
        z: z,
        origin_x: 0,
        origin_y: height / 2,
        width: width,
        height: height
      )

      item = item_class.new
      item.x = @x
      item.y = @y + height / 2 - item.sprite.height
      item.z = @z
      item.hide

      @item = item

      @lift_item_timer = Timer.new(LIFT_ITEM_TIMER)
      @get_item_timer = Timer.new(GET_ITEM_TIMER)
    end

    def entities
      entities = [] of Entity
      entities += super
      entities << @item.as(Item) if @item
      entities
    end

    def closed?
      !open?
    end

    def actionable?
      true
    end

    def actionable_condition?(entity : Entity)
      return false if open?

      super(entity)
    end

    def action(player : Player)
      open(player)
    end

    def open(player : Player)
      return if opened? || open?

      @open = true
      @player = player
    end

    def frame
      (@frame_t * FPS).to_i
    end

    def update(frame_time)
      super

      if open?
        @frame_t += frame_time

        if frame == sprite.frames - 1
          @open = false
          @opened = true
        end
      end

      if opened?
        if @lift_item_timer.done? && @item && @player.is_a?(Player)
          if @get_item_timer.done?
            if @player.try(&.receive_item(@item.as(Item)))
              @item = nil
            end
          else
            @get_item_timer.increase(frame_time)
          end
        else
          @lift_item_timer.increase(frame_time)

          @item.try do |item|
            item.show
            item.y -= LIFT_ITEM_MOVEMENT
          end
        end
      end
    end

    def draw(screen_x, screen_y)
      draw(
        screen_x: screen_x,
        screen_y: screen_y,
        frame: frame
      )
    end
  end
end
