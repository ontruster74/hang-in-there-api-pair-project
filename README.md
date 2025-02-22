# MOD 2 PAIR PROJECT - HANG IN THERE API
This project contains an basic internal API for manipulating a simple database of unmotivational poster data. It has 11 fully tested endpoints covering basic CRUD functionality and sort/filter query requests. It serves as a backend counterpart to the first project in Mod 2: Hang In There.

### COLLABORATORS
------------------------------
Donte Handy - GitHub Profile: https://github.com/dontehandy

Rig Freyr - GitHub Profile: https://github.com/ontruster74

### SETUP
---------------------------------

* Ruby version
  
    At least Ruby version 3.2.2 and Ruby on Rails 7.1.X is required for this project to function properly.

* Configuration
  
    The "rspec-rails," "pry," and "simplecov" gems are included in this project. Run $ bundle install in the project directory once you have cloned it down to your machine to ensure they function properly.

* Database creation/initialization
  
    Run $rails db:{drop,create,migrate,seed} to prepare the database for use.

    Then run $ rails console or $ rails dbconsole to interact with the database directly, or use $ rails s to start a rails server and test the project's functionality in the browser of your choice.

* How to run the test suite
  
    Run $ bundle exec rspec spec/requests/api/v1/posters_request_spec.rb to run the rspec test suite.

    To test the project's endpoints in Postman, import the following test suite: https://curriculum.turing.edu/module2/projects/hang_in_there_api/hang_in_there_api.postman_collection.json

    Then run $ rails s to start a rails server and send each of the provided test suite requests to the project individually. Only the first 11 requests are supported - Extensions/Sad Path functionality is not supported.

