task :daily_update => :envioment do
    User.each do |user|
        if user
            message="Plant summary for: "+ user.name
            user.plants.each do |plant|
                if plant
                    message+="\n"
                    message+="Plant: "+plant.name
                    message+="\n"
                    if plant.watered!
                        message+="Needs to be watered!"
                    else 
                        message+="Has been watered."
                    end
                    message+="\n"
                    if plant.sunlight!
                        message+="Needs to be put in sunlight!"
                    else
                        message+="Has been put in sunlight."
                    end
                    message+="\n"
                    if plant.trimmmed
                        message+="Has been trimmed."
                    end
                end
            end
            user.notify(message)
            message=""
        end
    end
end

task :rest_dailies => :enviroment do
    User.each do |user|
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