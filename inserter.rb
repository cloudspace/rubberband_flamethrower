require "httparty"
require "active_support/core_ext"
require_relative "models/data_generator.rb"

# set a starting id and initialize the random data generator
id = 2
data = DataGenerator.new

# start infinite loop
while true do  
  
  # generate a bit of random data to insert that approxiamates a tweet
  insert_data = data.generate_random_insert_data
  puts insert_data
  
  # insert the random data into elastic search index "twitter" as type "tweet"
  response = HTTParty.put("http://localhost:9200/twitter/tweet/#{id}", body: insert_data) 
  puts response.body
  
  #increment the insert id
  id = id + 1
end