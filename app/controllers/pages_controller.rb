class PagesController < ApplicationController

  # The following require is used to include the required libraries to work on json. 
  require 'json'
  # Nokogiri is a gem required to parse the XML format into the rails application. 
  require 'nokogiri'
  # Open-uri is used to open a XML/Json formatted url into the Rails Application.
  require 'open-uri'

  def home 
  end
  
  # local weather API Json
  def index
    # @json = ActiveSupport::JSON.decode(open('http://api.worldweatheronline.com/premium/v2/weather.ashx?q=Melbourne&format=json&num_of_days=5&key=543f0a44942a4081ace10734202108').read)
    @json = ActiveSupport::JSON.decode(open('http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=9b732f988a82cb5ec7499a0d0e6416ff').read)

  end

  
end
