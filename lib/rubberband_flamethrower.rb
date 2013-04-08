module RubberbandFlamethrower
  def self.fire(how_many=5000, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")
    require "active_support/core_ext"
    require 'httparty'
    require File.dirname(__FILE__)+"/rubberband_flamethrower/data_generator.rb"
    require File.dirname(__FILE__)+"/rubberband_flamethrower/flamethrower.rb"
    flamethrower = Flamethrower.new
    flamethrower.fire(how_many, starting_id, server_url, index, type)
  end

  def self.help
    puts "Flamethrower Commands Available:\n\nflamethrower #display this help message\nflamethrower fire #sends a batch to the elastic search server"
  end

end
