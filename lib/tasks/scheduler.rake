task :daily_update => :envioment do
    @users.each do |user|
        message="Plant summary for: "+user.name
        if @user
            @plants.each do |plant|
                if @plant
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
            @user.notify(message)
            message=""
        end
    end
end

task :rest_dailies => :enviroment do
    @users.each do |user|
        if @user&&Time.beginning_of_week() < @user.last_active
            @plant.watered = false
            @plant.sunlight = false
            @plant.trimmed = false
        end
    end
end
