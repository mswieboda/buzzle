require "cray"
require "./buzzle/obj"
require "./buzzle/entity"
require "./buzzle/sprite_entity"
require "./buzzle/switch"
require "./buzzle/*"
require "./buzzle/door/*"
require "./buzzle/floors/*"
require "./buzzle/rooms/*"
require "./buzzle/scenes/*"

module Buzzle
  def self.run
    Game.new.run
  end
end

Buzzle.run
