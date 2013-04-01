require 'httparty'
require "active_support/core_ext"

while true do
  two_minutes_ago = (Time.now - 2.minutes).strftime "%Y%m%dT%H:%M:%S"
  three_minutes_ago = (Time.now - 3.minutes).strftime "%Y%m%dT%H:%M:%S"

  query = {query: {range: { postDate: {from: "#{three_minutes_ago}", to: "#{two_minutes_ago}"}}}}.to_json
  puts query

  response = HTTParty.get("http://localhost:9200/twitter/tweet/_search", body: query)
  puts response.body

end
