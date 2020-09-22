<<<<<<< Updated upstream
# Task to notify users of their plants status'
task :daily_update => :environment  do
    User.daily_notify
end
# Task to reset the daily chores
task :rest_dailies => :environment  do
    User.reset_daily
end
# Cretes a plant_record object with current plant values for all plants
task :record_plant_values => :enviroment do
    Plant.record_values
end
=======

#This file will handle the notifications
#Sent at 9:30 am every day

account_sid = 'AC1f9a60a66869c95de7e80492d52f3dd3'
auth_token = '4f1f5ec1a70f846ded523643f8ebb106'
client = Twilio::REST::Client.new(account_sid, auth_token)
@users = User.all
from = '+15005550000' # Your Twilio number
to = '+61413060331' # Your mobile phone number ------ "+" + user.phone = "+04,d{8}"

task daily_notify
    for user in @users 
    message = "Daily summary for " + user.name + " :"
    # for all users
        for plant in user.plants
            message+="\n"+"Plant: "+plant.name
        end
        # Uncomment when in production, default is Sean Clare's Phone for debug
        # to = user.phone
        client.messages.create(
            from: from,
            to: to,
            body: message
        )
        message=""
    end
end

task dailys_reset
    for plant in Plant.all
        plant.trimmed=false
        plant.sunlight=false
        plant.watered=false
        plant.save
    end
end
>>>>>>> Stashed changes
