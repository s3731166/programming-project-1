require File.dirname(__FILE__)  + "/../../app/models/application_controller"
require File.dirname(__FILE__)  + "/../../app/models/user"



task :daily_update => :environment  do
    @users = User.all
    @users.each do |user|
        if user
            message="Plant summary for: "+ user.name
            user.plants.each do |plant|
                if plant
                    message+="\n"
                    message+="Plant: "+plant.name
                    message+="\n"
                    if plant.watered?
                        message+="Has been watered."
                    else 
                        message+="Needs to be watered\!"
                    end
                    message+="\n"
                    if plant.sunlight?
                        message+="Has been put in sunlight."
                    else
                        message+="Needs to be put in sunlight\!"
                    end
                    message+="\n"
                    if plant.trimmed?
                        message+="Has been trimmed."
                    end
                end
            end
            user.notify(message)
            message=""
        end
    end
end

task :rest_dailies => :environment  do
    @users = User.all
    @users.each do |user|
        if user&&Time.beginning_of_week() <= user.last_active
            user.plants.each do |plant|
                if plant
                    plant.watered = false
                    plant.sunlight = false
                    plant.trimmed = false
                end
            end
        end
    end
end
