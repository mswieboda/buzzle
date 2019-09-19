require "cray"

require "./buzzle/core/**"
require "./buzzle/**"

module Buzzle
  def self.run
    Game.new.run
  end
end

Buzzle.run
