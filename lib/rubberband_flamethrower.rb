module RubberbandFlamethrower
  
  # Benchmarks a call to the fire method (which inserts a batch of random data into Elastic Search)
  # @param [Integer] how_many - how many randomly generated data objects to insert
  # @param [Integer] starting_id - starting id for randomly generated data objects, will increment from this number
  # @param [String] server_url - url of the Elastic Search server
  # @param [String] index - name of the Elastic Search index to insert data into
  # @param [String] type - name of the Elastic Search type to insert data into
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

  # Benchmarks a series of calls to the fire method (which inserts a batch of random data into Elastic Search)
  # @param [Integer] how_many_batches - how many batches to run
  # @param [Integer] per_batch - how many randomly generated data objects to insert
  # @param [Integer] starting_id - starting id for randomly generated data objects, will increment from this number
  # @param [String] server_url - url of the Elastic Search server
  # @param [String] index - name of the Elastic Search index to insert data into
  # @param [String] type - name of the Elastic Search type to insert data into
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

  # Displays help menu of the available help menu commands
  def self.help
    puts "Flamethrower Commands Available:\n"
    puts "flamethrower help #display this help message"
    puts "flamethrower fire #benchmark a batch insert of data to an elastic search server"
    puts "flamethrower auto #benchmark a series of batch inserts to an elastic search server"
  end

end
