class PagesController < ApplicationController

  # The following require is used to include the required libraries to work on json. 
  require 'json'
  # Nokogiri is a gem required to parse the XML format into the rails application. 
  require 'nokogiri'
  # Open-uri is used to open a XML/Json formatted url into the Rails Application.
  require 'open-uri'

  def home 
    if current_user
      @plants = current_user.plants 
    end
    
    @json = ActiveSupport::JSON.decode(open('http://api.openweathermap.org/data/2.5/weather?q=melbourne,au&APPID=9b732f988a82cb5ec7499a0d0e6416ff&units=metric').read)
  end
end
