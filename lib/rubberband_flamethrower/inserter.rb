# Rubberband Flamethrower is a collection of scripts for dealing with faked Elastic Search data. 
# This file is the main script for inserting fake data 
# It inserts fake "tweet" type objects into a "twitter" index 
# on a local Elastic Search server at localhost:9200.  
# It runs in an infinite loop until you stop it.
#
#
# Author::    Michael Orr 
#             email - michael@cloudspace.com 
#             twitter - @imbiat
# Copyright:: Copyright (c) 2013
# License::   MIT License


require_relative "data_generator.rb"

# a unique ID must be provided for each document stored in Elastic Search
# since we are looping, we set a starting id and it will be incremented in the loop
id = 2

# initialize the random data generator object
data = DataGenerator.new

# start infinite loop
while true do  
  
  # generate a piece of random data to insert that approxiamates a tweet
  insert_data = data.generate_random_insert_data
  puts insert_data
  
  # insert the random data into local elastic search index "twitter" as type "tweet" with set id
  response = HTTParty.put("http://localhost:9200/twitter/tweet/#{id}", body: insert_data) 
  puts response.body
  
  #increment the insert id
  id = id + 1
end