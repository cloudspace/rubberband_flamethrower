# This class is designed to insert objects created with the DataGenerator class into Elastic Search

require 'httparty'
require "benchmark"
require File.dirname(__FILE__)+"/data_generator.rb"

module RubberbandFlamethrower
  class Flamethrower

    # Batch inserts randomly generated JSON data objects into an Elastic Search server.
    # Example of the object inserted:
    #  {
    #   "message":"utilizing plowed popularizing demeanor anesthesia specializes chaperon pedaling.",
    #   "username":"pummeling",
    #   "post_date":"20130408T15:41:28"
    #  }
    # 
    # @param [Integer] how_many - how many randomly generated data objects to insert
    # @param [Integer] starting_id - starting id for randomly generated data objects, will increment from this number
    # @param [String] server_url - url of the Elastic Search server
    # @param [String] index - name of the Elastic Search index to insert data into
    # @param [String] type - name of the Elastic Search type to insert data into
    # @param [Integer] printing_level - 0 = no printing | 1 = progress dots | 2 = debug level
    def fire(how_many, starting_id, server_url, index, type, printing_level=0)

      # this will constantly flush the printing to the display so the progress dots appear for each insert
      ($stdout.sync = true) if printing_level == 1

      # a unique ID must be provided for each document stored in Elastic Search
      id = starting_id.to_i

      # initialize the random data generator object
      data = DataGenerator.new

      # loop through inserting random data
      how_many.to_i.times do |i|
        # generate a piece of random data to insert that approxiamates a tweet
        insert_data = data.generate_random_insert_data
        (puts insert_data) if printing_level == 2

        # insert the random data into local elastic search index "twitter" as type "tweet" with set id
        response = httparty_put("#{server_url}/#{index}/#{type}/#{id}", insert_data)
        (puts response.body) if printing_level == 2
        (print ".") if printing_level == 1

        #increment the insert id
        id = id + 1
      end
    end

    def load_dataset(filename, starting_id, server_url, index, type, printing_level=0)
      # this will constantly flush the printing to the display so the progress dots appear for each insert
      ($stdout.sync = true) if printing_level == 1
      # a unique ID must be provided for each document stored in Elastic Search
      id = starting_id.to_i
      # loop through lines in the file and insert each line, each line is a document from the data generator
      IO.foreach(filename) do |line|
        unless line.empty?
          (puts insert_data) if printing_level == 2
          response = httparty_put("#{server_url}/#{index}/#{type}/#{id}", line)
          (puts response.body) if printing_level == 2
          (print ".") if printing_level == 1
          id = id + 1
        end
      end
    end
    
    def httparty_put(url, body)
      HTTParty.put(url, body: body)
    end



  end
end
