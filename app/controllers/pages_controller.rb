class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:certbot_key]

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
  end

  def certbot_key
    render file: "pages/certbot_key", layout: false, content_type: 'text/plain'
  end

  def plant_graph
    # Assign values from AJAX change_graph method
    @plant_for_graph = params[:plant]
    if params[:report_value] == ":water_recorded"
      @report_value = :water_recorded
    else
      @report_value = :temp_recorded
    end
    @report_time = params[:report_time]
    respond_to do |format|
      format.js
     end
  end

  

end
