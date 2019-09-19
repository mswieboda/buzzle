require "cray"

require "./buzzle/sprite_entity"

require "./buzzle/door/*"
require "./buzzle/floor/*"
require "./buzzle/switch/*"

require "./buzzle/*"

require "./buzzle/room/*"
require "./buzzle/scene/*"

module Buzzle
  def self.run
    Game.new.run
  end
end

Buzzle.run
