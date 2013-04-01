require 'httparty'
require "active_support/core_ext"

while true do

  range_start = (Time.now - 3.minutes).strftime "%Y%m%dT%H:%M:%S"
  range_end = (Time.now - 2.minutes).strftime "%Y%m%dT%H:%M:%S"

  query = {query: {range: { postDate: {from: "#{range_start}", to: "#{range_end}"}}}}.to_json
  puts query

  response = HTTParty.get("http://localhost:9200/twitter/tweet/_search", body: query)
  parsed = JSON.parse(response.body)
  puts "hits found: #{parsed["hits"]["total"]}"
end
