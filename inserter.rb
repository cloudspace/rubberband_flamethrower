require 'httparty'
require "active_support/core_ext"

#combine several word files into an array of words
words = []
word_files = [
  # "./words/american-words.95",
  # "./words/american-words.80",
  # "./words/american-words.70",
  # "./words/american-words.60",
  # "./words/american-words.55",
  # "./words/american-words.50",
  # "./words/american-words.40",
  "./words/american-words.35",
  "./words/american-words.20",
  "./words/american-words.10"
  ]
word_files.each do |word_file|
  contents = File.read(word_file)
  words = words + contents.split(/\n/)
end

# set a starting id
id = 2

#start infinite loop
while true do  
  #create a message from between 6 and 16 random words that maxes at 140 characters
  number_of_words = 6 + rand(10)
  sentence = (number_of_words.times.map{words.sample}.join(" ")+".")[0,140]
  
  # create a username that is only letters and numbers
  username = words.sample.gsub(/[^0-9a-z]/i, '')
  
  #set a timestamp
  date = Time.now.strftime "%Y%m%dT%H:%M:%S"

  twitter_message = {user: "#{username}", postDate: "#{date}", message: "#{sentence}"}.to_json
  puts "twitter_message: #{twitter_message}"
  
  response = HTTParty.put("http://localhost:9200/twitter/tweet/#{id}", body: twitter_message) 
  puts response.body
  
  id = id + 1
end