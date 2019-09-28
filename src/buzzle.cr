require "cray"

require "./buzzle/sprite_entity"
require "./buzzle/floor/base"
require "./buzzle/switch"
require "./buzzle/**"

module Buzzle
  def self.run
    Game.new.run
  end
end

Buzzle.run
