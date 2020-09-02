class Plant < ApplicationRecord
    belongs_to :user

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
end
