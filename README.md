# programming-project-1

Web Application Development Master Branch

## Our Workflow/Visual Studio Live Share

We use a Visual Studio Code extension called Live Share for our coding sessions. This involves everyone collabaratively working on the code simultaneously, similar to working together in Google Drive. For this to work, all of the changes to this project are made on one team member's machine in any given session.

Because of this, work done by the group as a whole will usually be committed and pushed to the repository under one user's name, even though that user may not have neccessarily done all of that work alone, and it is usually a team effort between at least two team members.

## Licence

All work not mentioned below is built from scratch in Ruby on Rails by the SEED ORG Rails Team, Jessiah Malik, Sean Clare, Scott Ross and Marcus Geary and Glenn Iudice.

### Base User and Session Fuctionality
The user registration, log-in, log-out, and persistent session functionality of this program are built with the help of Michael Hartl's book *[Ruby in Rails Tutorial: Learn Web Development with Rails](https://www.learnenough.com/ruby-on-rails-6th-edition-tutorial#copyright_and_license)*, which is published under the MIT License and the Beerware License.

The Beerware Licence provided by Hartl can be found below.

```
THE BEERWARE LICENSE (Revision 42)

Michael Hartl wrote this code. As long as you retain this notice you can do
whatever you want with this stuff. If we meet some day, and you think this
stuff is worth it, you can buy me a beer in return.
```

The code built referencing this tutorial can be found in:
* app/controllers/users_controller.rb
* app/controllers/sessions_controller.rb
* app/helpers/sessions_helper.rb
* app/models/user.rb






### CODE INITIALISATION AND SETUP

Ruby: https://rubygems.org/pages/download
Rails: gem install rails
Gem Updates: $ gem update --system

- RUNNING ON LOCALHOST:

\-The Caveat here is the need for Postgresql To run the local DB. 
    - https://www.postgresql.org/download/

$ cd app
$ bundle
$ rails db:setup
$ rails db:migrate
$ rails s


Deployment To Heroku: 

Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli#download-and-install

$ heroku create
$ git push heroku master


    -- More on heroku Deployment with Git: https://devcenter.heroku.com/articles/git



Seeding Heroku: 
$ heroku rake:db seed

### API CONNECTION AND REGISTRATIONS 


*TWILIO* 

    - Link TO Registration: https://www.twilio.com/try-twilio
    - Required Data:                        models/user.rb: line 95-111
    - Where to Put Account ID in Code:      models/user.rb: line 24
    - Where to Put API ID in code:          models/user.rb: line 26 
    - Where to Put API Secret in code:      models/user.rb: line 28
    - Where to Put Phone Number in code:    models/user.rb: line 30


*OPEN WEATHER MAP*

    - Link TO Registration: https://openweathermap.org/api 
    - Required Data: views/pages/_weather_sumary.html.erb: Line 18+
    - Where to find and put key in Code:    models/plant.rb: Line 7
    - Json Format Required/Sanitisied:      Max and Min Temp by json["main"]["temp_max/temp_min"]
                                            Description by @json["weather"][0]["description"]

*TREFLE.IO*

    - Link TO Registration:                 https://trefle.io/
    - Required Data:                        model/plant.rb: line 80 - 88
                                            controllers/plants_controller.rb: line 24-42
                                            controllers/plants_controller.rb: line 66-151
                                            controllers/plants_controller.rb: line 191-262
    - Where to find and put key in Code:    model/plant.rb: line 12
                                            controllers/plants_controller.rb: line 9
    - Json Format Required/Sanitisied: 
                   For search results: 
                    common name:            json["data"][<result number>]["common_name"]
                    Scientific name:        json["data"][<result number>]["scientific_name"]
                    Image associated:       json["data"][<result number>]["image_url"]
                    trefle id:              json["data"][<result number>]["id"]
                   For get results:
                    Maximum temperature:    json["data"]["growth"]["maximum_temperature"]["deg_c"]
                    Minimum temperature:    json["data"]["growth"]["minimum_temperature"]["deg_c"]
                    light level:            json["data"]["growth"]["light"]
                    Minimum precipitation:  json["data"]["growth"]["minimum_precipitation"]["mm"]
                    Maximum precipitation:  json["data"]["growth"]["maximum_precipitation"]["mm"]
                   


*Gravatar (Gem API: 'gravtastic', '~> 3.2', '>= 3.2.6')*
    -Sourced in Gemfile line 44

    - Link TO Registration:                 Gets via user email in parital '_header.html.erb: Line 24'
    - Required Data:                        User Email If Registered 

*Geocoder (Gem API: 'geocoder', '~> 1.6', '>= 1.6.3')*
    -Sourced in Gemfile line 86
    - Required Data:                        controllers/plants_controller: lines 110-116
    - Json Format Required/Sanitisied:      
                   From search:
                    location coordinates:   First.coordinates


## HOW TO RUN TESTS 
-filepath
$command