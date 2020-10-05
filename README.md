# programming-project-1

Web Application Development Master Branch

## Our Workflow/Visual Studio Live Share

We use a Visual Studio Code extension called Live Share for our coding sessions. This involves everyone collabaratively working on the code simultaneously, similar to working together in Google Drive. For this to work, all of the changes to this project are made on one team member's machine in any given session.

Because of this, work done by the group as a whole will usually be committed and pushed to the repository under one user's name, even though that user may not have neccessarily done all of that work alone, and it is usually a team effort between at least two team members.

## Licence

All work not mentioned below is built from scratch in Ruby on Rails by the SEED ORG Rails Team, Jessiah Malik, Sean Clare, Scott Ross and Marcus Geary.

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






### API CONNECTION AND REGISTRATIONS 


*TWILLIO* 

    - Link TO Registration
    - Required Data
    - Where to find and put key in Code
    - Json Format Required/Sanitisied


*OPEN WEATHER MAP*

    - Link TO Registration : https://openweathermap.org/api 
    - Required Data: views/pages/_weather_sumary.html.erb: Line 18+
    - Where to find and put key in Code: models/plant.rb: Line 7
    - Json Format Required/Sanitisied: Max and Min Temp by json["main"]["temp_max/temp_min"].to_d.round 
                                        Description by @json["weather"][0]["description"]

*TREFEL.IO*

    - Link TO Registration
    - Required Data
    - Where to find and put key in Code * abstracted to top of file TO-DO
    - Json Format Required/Sanitisied 

*Gravatar (Gem API: 'gravtastic', '~> 3.2', '>= 3.2.6')*
    -Sourced in Gemfile line 44

    - Link TO Registration: Gets via user email in parital '_header.html.erb: Line 24'
    - Required Data: User Email If REgistered 

*Geocoder (Gem API: 'geocoder', '~> 1.6', '>= 1.6.3')*
    -Sourced in Gemfile line 86

    - Link TO Registration
    - Required Data
    - Where to find and put key in Code
    - Json Format Required/Sanitisied