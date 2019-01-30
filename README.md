# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 2.5.3/ Rails 5.2 +

* System dependencies - Windows OS

First run "bundle install"
if any error on gem installation for sqlite3, try commenting out the ", git: "https://github.com/larskanis/sqlite3-ruby", branch: "add-gemspec" part

TIPS for accessing DB:

#opens up sqlite3 through rails
> rails db 

#turn headers on and show database data in column mode, for readability

sqlite >.headers on 

sqlite >.mode columns

#see table structure

sqlite >pragma table_info(your_table); 


DROP & CREATE db: (update db changes)

>rake db:drop:all >rake db:create:all >rake db:migrate

If you use Rails version < 4.1, don't forget to prepare test database:

>rake db:test:prepare

If you get permission denied error, just delete development.sqlite3 & schema.rb files and run rake db:migrate command

tutorial on saving images: https://www.youtube.com/watch?v=fVtGy3QL9xg


HAPPY CODING!



