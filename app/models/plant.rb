class Plant < ApplicationRecord
  belongs_to :user
  has_many :plant_records, dependent: :destroy
  has_one_attached :plant_pic
  validates :name, presence: true
  # VALID_COORD_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # (-?\d+(\.\d+)?),\s*(-?\d+(\.\d+)?)
  # validates :location, presence: true, format: {with: VALID_EMAIL_REGEX}
  
  #Weather API secret 
  @@weatherKey = '9b732f988a82cb5ec7499a0d0e6416ff'
  # Treffle ID Authentication token
  @@treffle_token = "1EuNspuzlsLWfDRrSfNIMpAUqcWNGvb3M0IQ__GxGTs"

  def get_weather
    lon=location.split(', ')[1]
    if lon 
      lon=lon.tr(']','')
    end
    lat=location.split(', ')[0]
    if lat
      lat=lat.tr('[','')
    end
    if lat && lon then
      # Don't know why, but this only functions when on one line
      ActiveSupport::JSON.decode(open("http://api.openweathermap.org/data/2.5/weather?lat="+lat+"&lon="+lon+"&APPID="+@@weatherKey+"&units=metric").read)
    end
  end

  def get_forecast
    splitLoc = location.split(',')
    lon=location.split(', ')[1]
    if lon then lon=lon.tr(']','') end
    lat=location.split(', ')[0]
    if lat then lat=lat.tr('[','') end
    # Returns the next 7 days forecast inclusive of current day
    # format is JSON in daily serperators
    # example: http://api.openweathermap.org/data/2.5/onecall?
    if lat && lon then ActiveSupport::JSON.decode(open("http://api.openweathermap.org/data/2.5/onecall?lat="+lat+"&lon="+lon+"&APPID="+@@weatherKey+"&units=metric&exclude=current,minutely,hourly,alerts").read)
    end
  end
  

  def Plant.record_values
    plants = Plant.all
    plants.each do |plant|
      # Build a plant record for this plant if there is a water level, and add if has been watered
      record = PlantRecord.new()
      if plant.daily_water and plant.watered
        record.water_recorded = plant.daily_water
      else
        record.water_recorded = nil
      end
      
      # Record average tempatrure for day
      weatherJson = plant.get_weather()
      if weatherJson["main"]
        averageWeather = (weatherJson["main"]["temp_max"]+weatherJson["main"]["temp_min"]) / 2
        record.temp_recorded = averageWeather
      end
      if record
        plant.plant_records << record
        record.save
      end
    end
  end

  # Removes all plant records over 1 year old
  def Plant.remove_old_records
    plants = Plant.all
    plants.each do |plant|
      records = plant.plant_records
      records.order(created_at: :asc).each do |record|
        if record.created_at<1.year.ago
          PlantRecord.delete(record.id)
        else
          # Small optimisation due to ordering
          break
        end
      end
    end
  end

  def get_plant    
    results = HTTParty.get(
      'https://trefle.io/api/v1/species/'+ treffleID.to_s,
    query: {
      "token": @@treffle_token
    })
    results.parsed_response
  end
end
