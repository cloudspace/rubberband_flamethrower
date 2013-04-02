# Rubberband Flamethrower is a collection of scripts for dealing with faked Elastic Search data. 
# This file is the main script for retrieving fake data 
# When running it will loop continuously
# doing a search on the tweets type in the twitter index
# for all objects within the date range between 2 and 3 minutes ago
# and reports the number of objects found.
#
# This can be used to easily approximate the maximum speed obtainable 
# for inserting to a local Elastic Search index for a given AWS box size.
#
#
# Author::    Michael Orr 
#             email - michael@cloudspace.com 
#             twitter - @imbiat
# Copyright:: Copyright (c) 2013
# License::   MIT License


require 'httparty'
require "active_support/core_ext"

# start infinite loop
while true do

  # set up start and end range values for query
  range_start = (Time.now - 3.minutes).strftime "%Y%m%dT%H:%M:%S"
  range_end = (Time.now - 2.minutes).strftime "%Y%m%dT%H:%M:%S"

  # set up json for elastic search range query
  query = {query: {range: { postDate: {from: "#{range_start}", to: "#{range_end}"}}}}.to_json
  puts query

  # perform elastic search query and report results
  response = HTTParty.get("http://localhost:9200/twitter/tweet/_search", body: query)
  parsed = JSON.parse(response.body)
  puts "hits found: #{parsed["hits"]["total"]}"
end
