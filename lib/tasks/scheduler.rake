# require File.dirname(__FILE__)  + "/../../app/models/application_controller"
# require File.dirname(__FILE__)  + "/../../app/models/user"



task :daily_update => :environment  do
    User.daily_notify
end

task :rest_dailies => :environment  do
    User.reset_daily
end
