require "cray"
require "./buzzle/*"

module Buzzle
  def self.run
    Game.new.run
  end
end

Buzzle.run
