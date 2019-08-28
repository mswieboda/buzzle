require "cray"
require "./buzzle/entity"
require "./buzzle/sprite_entity"
require "./buzzle/*"
require "./buzzle/rooms/*"

module Buzzle
  def self.run
    Game.new.run
  end
end

Buzzle.run
