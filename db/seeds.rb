# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Users
puts("Creating users...")
User.create(name: "admin", email: "admin@thissite.com", password: "Password", phone: "0413060331",
 admin: true, recieve_texts: true, competitive: true, points: 0)
count = 1
until count>4 do
    count+=1
    User.create(name: "user "+count.to_s, email: "user"+count.to_s+"@email.com", password: "Password", phone: '0'+(413060331+count).to_s,
         admin: false, recieve_texts: false, competitive: true, points: 0)
end

puts("Created users!")
puts("Creating plants...")
User.all.each do |user|
    count=1
    Plant.create(name: "Plant "+count.to_s, locationName: "Melbourne, Australia", location: "[-37.8142176, 144.9631608]",
        species: "Common sunflower", daily_water: 500, min_temp: 15, max_temp: 30, treffleID: 141504,
         outside: true, user_id:user.id)
         count+=1
    Plant.create(name: "Plant "+count.to_s, locationName: "Republic of Molossia, United States of America", location: "[39.3227801, -119.53936065012009]",
        species: "Peace-lily", daily_water:50, min_temp:12, max_temp:25, treffleID: 223336,
         outside:false, user_id:user.id)
         count+=1
    Plant.create(name: "Plant "+count.to_s, locationName: "Moscow, Russia", location: "[55.7504461, 37.6174943]",
        species: "Irish potato", daily_water:50, min_temp:-10, max_temp:30, treffleID: 182597,
         outside:true, user_id:user.id)
         count+=1
    Plant.create(name: "Plant "+count.to_s, locationName: "Okinawa, Japan", location: "[26.3343738, 127.8056597]",
        species: "Bonsai crassula", daily_water:100, min_temp:15, max_temp:27, treffleID: 123808,
         outside:false, user_id:user.id)
end
puts("Created plants!")

puts("Creating records...")
Plant.all.each do |plant|
    puts("Creating history for id: "+plant.id.to_s+"...")
    365.times do |i|
        if rand()>0.2
            PlantRecord.create(temp_recorded:rand(-10..30), water_recorded: plant.daily_water, plant_id: plant.id, created_at: i.days.ago)
        else 
            PlantRecord.create(temp_recorded:rand(-10..30), water_recorded: nil, plant_id: plant.id, created_at: i.days.ago)
        end
    end
    puts("Created history for id: "+plant.id.to_s)
end
puts("Created records!")