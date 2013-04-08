# This class is designed to insert objects created with the DataGenerator class into Elastic Search
module RubberbandFlamethrower
  class Flamethrower
    def fire(how_many, starting_id, server_url, index, type)
      # a unique ID must be provided for each document stored in Elastic Search
      id = starting_id.to_i

      # initialize the random data generator object
      data = DataGenerator.new

      how_many.to_i.times do |i|

        # generate a piece of random data to insert that approxiamates a tweet
        insert_data = data.generate_random_insert_data
        #puts insert_data

        # insert the random data into local elastic search index "twitter" as type "tweet" with set id
        response = HTTParty.put("#{server_url}/#{index}/#{type}/#{id}", body: insert_data) 
        #puts response.body

        #increment the insert id
        id = id + 1
      end
      puts "Finished Inserting #{how_many} documents into Elastic Search."
    end
    
  end
end
