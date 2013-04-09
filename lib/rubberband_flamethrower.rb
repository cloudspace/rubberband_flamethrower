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
    puts "Rubberband Flamethrower is a gem for inserting faked data into an Elastic Search server"
    puts "and providing basic benchmarks. It creates and inserts fake data objects with three"
    puts "fields (message, username, and post_date) and reports timing information.\n"
    
    puts "Flamethrower Commands Available:\n"
    puts "flamethrower fire #benchmark a batch insert of data to an elastic search server"
    puts "flamethrower auto #benchmark a series of batch inserts to an elastic search server"
    puts "flamethrower help #display this help message"
    
    puts "\nThe fire and auto commands can be configured by passing arguments."
    puts "The parameters accepted by the `flamethrower fire` command all have a default value if"
    puts "left blank. Here are the parameters in order with their default values:"
    puts "(how_many=500, starting_id=1, server_url=http://localhost:9200, index=twitter, type=tweet)\n"
    
    puts "Command Examples Using Parameters:"
    puts "flamethrower fire 10000 #To Insert 10,000 instead of 500"
    puts "flamethrower fire 5000 5001 #To Insert 5,000 starting with the ID 5001"
    puts "flamethrower fire 2000 1 \"http://es.com:9200\" #To Insert 2,000 starting with the ID 1 to"
    puts "\t\t\ta server located at http://es.com:9200"
    puts "flamethrower fire 500 1 \"http://localhost:9200\" \"facebook\" \"message\" #To put your"
    puts "\t\t\tdocuments into an index named \"facebook\" instead of \"twitter\" with a type of"
    puts "\t\t\t\"message\" instead of \"tweet\""
  end

end
