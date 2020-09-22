class Plant < ApplicationRecord
  belongs_to :user
  has_many :plant_records

  def get_weather
    #ActiveSupport::JSON.decode(open('http://api.openweathermap.org/data/2.5/weather?q=melbourne,au&APPID=9b732f988a82cb5ec7499a0d0e6416ff&units=metric'
    #@json = ActiveSupport::JSON.decode(open('http://api.openweathermap.org/data/2.5/weather?lat='+splitLoc[0][1:]+'lon='+splitLoc[1][:-1]+'&APPID=9b732f988a82cb5ec7499a0d0e6416ff&units=metric').read)
    splitLoc = location.split(',')
    lon=location.split(', ')[1]
    #lon=lon[:-1]
    if lon then lon=lon.tr(']','') end
    lat=location.split(', ')[0]
    #lat=lat[1:]
    if lat then lat=lat.tr('[','') end
    if lat and lon then ActiveSupport::JSON.decode(open('http://api.openweathermap.org/data/2.5/weather?lat='+lat+'&lon='+lon+'&APPID=9b732f988a82cb5ec7499a0d0e6416ff&units=metric').read) end
  end

  def Plant.record_values
    @plants = Plant.all
    # loop through all plants
    @plants.each do |plant|
      # Set record to nil at first
      record=nil
      # Build a plant record for this plant if there is a water level, and add the water level o the record
      if plant.daily_water and plant.watered
        record = PlantRecord.new()
        record.water_recorded = plant.daily_water
      end
      
      # Record average tempatrure for day
      weatherJson = @plant.get_weather
      if weatherJson["main"]
        averageWeather = (weatherJson["main"]["temp_max"]+weatherJson["main"]["temp_min"]) / 2
        if !record
          record = PlantRecord.new()
        end
        record.temp_recorded = averageWeather
      end
      # If the record has a value, save the record
      if record
        plant.plant_records << record
        record.save
      end
    end
  end

end
