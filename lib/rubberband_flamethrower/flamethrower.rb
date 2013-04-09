# This class is designed to insert objects created with the DataGenerator class into Elastic Search
module RubberbandFlamethrower
  class Flamethrower
    def fire(how_many, starting_id, server_url, index, type, printing_level=0)

      
      ($stdout.sync = true) if printing_level == 1

      # a unique ID must be provided for each document stored in Elastic Search
      id = starting_id.to_i

      # initialize the random data generator object
      data = DataGenerator.new

      how_many.to_i.times do |i|

        # generate a piece of random data to insert that approxiamates a tweet
        insert_data = data.generate_random_insert_data
        (puts insert_data) if printing_level == 2

        # insert the random data into local elastic search index "twitter" as type "tweet" with set id
        response = HTTParty.put("#{server_url}/#{index}/#{type}/#{id}", body: insert_data) 
        (puts response.body) if printing_level == 2
        (print ".") if printing_level == 1

        #increment the insert id
        id = id + 1
      end
    end
    
  end
end
