module RubberbandFlamethrower
  def self.fire(how_many=5000, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")
    require File.dirname(__FILE__)+"/rubberband_flamethrower/flamethrower.rb"
    flamethrower = Flamethrower.new
    time = Benchmark.measure do
      flamethrower.fire(how_many, starting_id, server_url, index, type, 1)
    end
    puts "\nFinished Inserting #{how_many} documents into Elastic Search."
    puts "  user       system     total    real"
    puts time
  end

  def self.auto(how_many_batches=3, per_batch=5000, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")
    require File.dirname(__FILE__)+"/rubberband_flamethrower/flamethrower.rb"
    flamethrower = Flamethrower.new
    Benchmark.bm(8) do |x|
      how_many_batches.to_i.times do |i|
        x.report("set #{i+1}:")   { flamethrower.fire(per_batch, starting_id, server_url, index, type) }
        starting_id = starting_id.to_i + per_batch.to_i
      end
    end
  end

  def self.help
    puts "Flamethrower Commands Available:\n\nflamethrower #display this help message\nflamethrower fire #sends a batch to the elastic search server"
  end

end
