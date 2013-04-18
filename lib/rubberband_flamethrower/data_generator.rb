# This class is specially designed to generate random data to be inserted into Elastic Search
# It creates a JSON object that approaxiamates data like you would fine in a tweet
# with fields for a message (max 140 characters), username, and post_date.
# The post_date format is parsable as a date object by default by Elastic Search

require "active_support/core_ext"


module RubberbandFlamethrower
  class DataGenerator
    attr_accessor :word_list
  
    # the WORD_FILES constant is an array of included word files
    # which will be used to create the pool of random words used for data generation.
    # You can uncomment or comment particular files to change the size of the pool of words.
    # Please see the README file in the words folder for more information about the lists.
    WORD_FILES = [
      # "/words/american-words.95",
      # "/words/american-words.80",
      # "/words/american-words.70",
      # "/words/american-words.60",
      # "/words/american-words.55",
      # "/words/american-words.50",
      # "/words/american-words.40",
      "/words/american-words.35",
      "/words/american-words.20",
      "/words/american-words.10"
      ]

    # Will initialize the word_list variable with an array of all the words contained in the WORD_FILES array   
    def initialize
      self.word_list = []
      WORD_FILES.each do |word_file|
        contents = File.read(File.dirname(__FILE__)+word_file)
        self.word_list = word_list + contents.split(/\n/)
      end
    end
  
    # create a message from between 6 and 16 random words that maxes at 140 characters and ends with a period
    # @return [String]
    def random_tweet
      number_of_words = 6 + rand(10)
      ((number_of_words.times.map{word_list.sample}.join(" "))[0,139])+"."
    end
  
    # create a random value to be used as a username
    # the return value is one random word, only letters and numbers allowed
    # @return [String]
    def random_username
      word_list.sample.gsub(/[^0-9a-z]/i, '')
    end
  
    # create an Elastic Search friendly timestamp for right now
    # @return [String]
    def current_timestamp
      Time.now.strftime "%Y%m%dT%H:%M:%S"
    end  
  
    # generate a JSON object that contains a message, username, and post_date
    # intended to be passed as insert data to an elastic search server
    # @return [JSON]
    def generate_random_insert_data
      {message: "#{random_tweet}", username: "#{random_username}", post_date: "#{current_timestamp}"}.to_json
    end
 
    def generate_dataset(batch_size, filename)
      File.open(filename, 'w') do |file|
        batch_size.to_i.times do |i|
          file.write(generate_random_insert_data+"\n") 
        end
      end
    end


 
  end
end
