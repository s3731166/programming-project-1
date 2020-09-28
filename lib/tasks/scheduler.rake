# Task to notify users of their plants status'
task :daily_update => :environment  do
    User.daily_notify
end
# Task to reset the daily chores
task :reset_dailies => :environment  do
    User.reset_daily
end
# Cretes a plant_record object with current plant values for all plants
task :record_plant_values => :environment do
    Plant.record_values
end

task :forecast_check => :environment do
    User.danger_check
end

task :calculate_score => :enviroment do
    User.calculate_score
end