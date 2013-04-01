require 'httparty'
require "active_support/core_ext"

#combine several word files into an array of words
contents = File.read('./words/american-words.35')
words = contents.split(/\n/)
contents = File.read('./words/american-words.20')
words = words + contents.split(/\n/)
contents = File.read('./words/american-words.10')
words = words + contents.split(/\n/)
puts "number of total base words: #{words.length}"

id = 2

#start infinite loop
while true do
  
  #create a message from between 6 and 16 random words that maxes at 140 characters
  number_of_words = 6 + rand(10)
  sentence = (number_of_words.times.map{words.sample}.join(" ")+".")[0,140]
  #puts "sample sentence id #{id}\n#{sentence}\nnumber of characters #{sentence.length}"
  
  # create a username that is only letters and numbers
  username = words.sample.gsub(/[^0-9a-z]/i, '')
  #puts "by user: #{username}"
  
  #set a timestamp
  date = Time.now.strftime "%Y%m%dT%H:%M:%S"

  twitter_message = {user: "#{username}", postDate: "#{date}", message: "#{sentence}"}.to_json
  puts "twitter_message: #{twitter_message}"
  
  response = HTTParty.put("http://localhost:9200/twitter/tweet/#{id}", body: twitter_message) 
  puts response.inspect
  puts response.body
  #insert into elasticsearch with curl
  # curl -XPUT localhost:9200/twitter/tweet/{id} -d '
  # {
  #   user : "{username}",
  #   message : "{sentence}",
  #   postDate : "{date}"
  # }'

  id = id + 1
end