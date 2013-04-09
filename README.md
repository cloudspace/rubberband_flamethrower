# Rubberband Flamethrower

Rubberband Flamethrower is a gem for inserting faked data into an Elastic Search server and providing basic benchmarks. It creates and inserts fake data objects with three fields (message, username, and post_date) and times the process. It inserts in batches of 500 objects by default but can be configured to insert any number of objects. Here is an sample generated data object:

	{
		"message":"utilizing plowed popularizing demeanor anesthesia specializes chaperon pedaling.",
		"username":"pummeling",
		"post_date":"20130408T15:41:28"
	}
	

## Pre-Requisites

### Elastic Search

You should install and have an Elastic Search node running before trying to use this gem.

Download Elastic Search:

	curl -k -L -o elasticsearch-0.20.6.tar.gz http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.6.tar.gz

Unarchive Elastic Search:

	tar -zxvf elasticsearch-0.20.6.tar.gz

Start an Elastic Search node:

	./elasticsearch-0.20.6/bin/elasticsearch -f

### Ruby

It has been designed with ruby 1.9.1 and above in mind. The sample method of the Array class is used in the code and was not a part of the 1.8.7 release.

## Installation

install the gem manually

	gem install rubberband_flamethrower

Or if you will be using this as a part of a Rails project, you can add the gem to your Gemfile and then `bundle install`.

## Flamethrower Use

### Command Line Executable

Once the gem is installed and you have an Elastic Search server running you are ready to begin inserting fake data. You can run the gem from the command line using the "flamethrower" command.  

#### Fire

To start a batch insert into the local Elastic Search server you add the argument "fire" to the command:

	flamethrower fire

By default it will insert 500 documents starting with document ID 1 into an Elastic Search index named "twitter" of type "tweet" into a server node located at http://localhost:9200.

You can configure what is inserted by passing additional parameters. The parameters accepted by the `flamethrower fire` command all have a default value if left blank. Here are the parameters in order with their default values: (how_many=500, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")

To Insert 10,000 instead of 500:

	flamethrower fire 10000

To Insert 5,000 starting with the ID 5001

	flamethrower fire 5000 5001

To Insert 2,000 starting with the ID 1 to a server located at http://es.com:9200

	flamethrower fire 2000 1 "http://es.com:9200"

To put your documents into an index named "facebook" instead of "twitter" with a type of "message" instead of "tweet"

	flamethrower fire 500 1 "http://localhost:9200" "facebook" "message"

#### Auto

The "auto" argument can be used to repeatedly run the "flamethrower fire" command, timing each run.  By default it will run the command 3 times.

	flamethrower auto

This can be configured much like the above example, though there is one additional parameter, which is supplied first and represents the number of times to run the "flamethrower fire" command. Here are the parameters in order with their default values: (how_many_batches=3, per_batch=500, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet", id_overwrite="n")

To run the "flamethrower fire" command 5 times in a row instead of the default 3:

	flamethrower auto 5

To run the "flamethrower  fire" command 5 times, inserting 5,000 objects each time:

	flamethrower auto 5 5000
	
The id_overwrite parameter determines the ID strategy used for subsequent batches in the auto command. When set to \"n\" (which it is by default) each batch will be writing new data with fresh IDs to the Elastic Search server, simulating a system where data is constantly being inserted and not updated. 5 batches of 500 with an \"n\" would use the IDs 1-2,500. When it is set to \"y\" each batch will simulate overwriting existing data in the Elastic Search server, simulating a system where data is constantly being updated (after the initial batch). 5 batches of 500 with a setting of \"y\" would use the IDs 1-500 on each batch.
	
#### Help

The command with the argument "help" or without any arguments will display the help screen:

	flamethrower help

### IRB/Ruby Scripts

Instead of using the gem from the command line you may want to use this gem from inside of a ruby script or through IRB.

First require the gem:

	require 'rubberband_flamethrower'

Then you are ready to use it!

	RubberbandFlamethrower.fire

By default it will insert 500 documents starting with document ID 1 into an Elastic Search index named "twitter" of type "tweet" into a server node located at http://localhost:9200.
	
The fire method can be configured by passing parameters to it. There are 5 parameters accepted by the fire method, all of which have a default value if left blank. Here are the parameters in order with their default values: (how_many=500, starting_id=1, server_url="http://localhost:9200", index="twitter", type="tweet")

To Insert 10,000 instead of 500:

	RubberbandFlamethrower.fire(10000)

To Insert 5,000 starting with the ID 5001

	RubberbandFlamethrower.fire(5000, 5001)

To Insert 2,000 starting with the ID 1 to a server located at http://es.com:9200

	RubberbandFlamethrower.fire(2000, 1,"http://es.com:9200")

To put your documents into an index named "facebook" instead of "twitter" with a type of "message" instead of "tweet"

	RubberbandFlamethrower.fire(500, 1, "http://localhost:9200", "facebook", "message")

## Contributing to rubberband_flamethrower
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Michael Orr. See LICENSE.txt for
further details.

