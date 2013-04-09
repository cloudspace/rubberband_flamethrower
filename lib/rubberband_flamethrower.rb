module RubberbandFlamethrower
  
  # Benchmarks a call to the fire method (which inserts a batch of random data into Elastic Search)
  # @param [Integer] how_many - how many randomly generated data objects to insert
  # @param [Integer] starting_id - starting id for randomly generated data objects, will increment from this number
  # @param [String] server_url - url of the Elastic Search server
  # @param [String] index - name of the Elastic Search index to insert data into
  # @param [String] type - name of the Elastic Search type to insert data into
  def self.fire(how_many=500, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")
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
  def self.auto(how_many_batches=3, per_batch=500, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet", id_overwrite="n")
    require File.dirname(__FILE__)+"/rubberband_flamethrower/flamethrower.rb"
    flamethrower = Flamethrower.new
    puts "#{per_batch} documents inserted into Elastic Search per set"
    Benchmark.bm(8) do |x|
      how_many_batches.to_i.times do |i|
        x.report("set #{i+1} of #{how_many_batches}:")   { flamethrower.fire(per_batch, starting_id, server_url, index, type) }
        # increment the starting id  by the batch size on each loop unless "id_overwrite" is set to "y"
        # when it is set to "n" (which it is by default)
        # each batch will be writing new data with fresh IDs to the Elastic Search server
        # simulating a system where data is constantly being inserted and not updated
        # when it is set to "y" each batch will simulate overwriting existing data in the Elastic Search server
        # simulating a system where data is constantly being updated (after the initial batch)
        (starting_id = starting_id.to_i + per_batch.to_i) unless id_overwrite == "y"
      end
    end
  end

  # Displays help menu of the available help menu commands
  def self.help
    puts "Rubberband Flamethrower is a gem for inserting faked data into an Elastic Search server"
    puts "and providing basic benchmarks. It creates and inserts fake data objects with three"
    puts "fields (message, username, and post_date) and reports timing information."
    
    puts "\n\nFlamethrower Commands Available:\n\n"
    puts "flamethrower fire #benchmark a batch insert of data to an elastic search server"
    puts "flamethrower auto #benchmark a series of batch inserts to an elastic search server"
    puts "flamethrower help #display this help message"
    
    puts "\n\nThe fire and auto commands can be configured by passing arguments."
    puts "The parameters accepted by fire and auto all have a default value if left blank."
    
    puts "\n\n\"fire\" parameters in order with their default values:"
    puts "(how_many=500, starting_id=1, server_url=http://localhost:9200, index=twitter, type=tweet)"

    puts "\n\n\"auto\" parameters in order with their default values:"
    puts "(how_many_batches=3, per_batch=500, starting_id=1, server_url=http://localhost:9200, index=twitter, type=tweet, id_overwrite=n)"
    
    puts "\n\nUsage Examples With Parameters:"
    puts "flamethrower fire 10000 #To Insert 10,000 instead of 500"
    puts "flamethrower fire 5000 5001 #To Insert 5,000 starting with the ID 5001"
    puts "flamethrower fire 2000 1 \"http://es.com:9200\" #Elastic Search Node located at http://es.com:9200"
    puts "flamethrower fire 500 1 \"http://localhost:9200\" \"facebook\" \"message\""
    puts "\t#Insert into an index named \"facebook\" instead of \"twitter\""
    puts "\t#with a type of \"message\" instead of \"tweet\""
    
    puts "\n\nThe id_overwrite parameter determines the ID strategy used for subsequent batches in the auto command."
    puts "When set to \"n\" (which it is by default)each batch will be writing new data with fresh IDs to the Elastic"
    puts "Search server, simulating a system where data is constantly being inserted and not updated. When it is set
    puts "to \"y\" each batch will simulate overwriting existing data in the Elastic Search server, simulating a"
    puts "system where data is constantly being updated (after the initial batch)."
  end

end
