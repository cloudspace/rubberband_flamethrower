module RubberbandFlamethrower
  def self.send_batch(how_many=5000, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")
    require "active_support/core_ext"
    require 'httparty'
    require File.dirname(__FILE__)+"/rubberband_flamethrower/data_generator.rb"
    require File.dirname(__FILE__)+"/rubberband_flamethrower/flamethrower.rb"
    flamethrower = Flamethrower.new
    flamethrower.send_batch(how_many, starting_id, server_url, index, type)
  end

  def self.help
    puts "Commands Available:\nflamethrower fire #sends a batch to the elastic search server"
  end

end
