module RubberbandFlamethrower
  def self.start_insert(how_many=50000, starting_id=2)
    require_relative "rubberband_flamethrower/data_generator.rb"

    # a unique ID must be provided for each document stored in Elastic Search
    id = starting_id

    # initialize the random data generator object
    data = DataGenerator.new

    how_many.times.do |i|

      # generate a piece of random data to insert that approxiamates a tweet
      insert_data = data.generate_random_insert_data
      puts insert_data

      # insert the random data into local elastic search index "twitter" as type "tweet" with set id
      response = HTTParty.put("http://localhost:9200/twitter/tweet/#{id}", body: insert_data) 
      puts response.body

      #increment the insert id
      id = id + 1
    end
    puts "Finished Inserting #{how_many} documents into Elastic Search."
  end
end