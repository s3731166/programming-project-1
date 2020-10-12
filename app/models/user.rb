class User < ApplicationRecord
    include Gravtastic
        gravtastic
    include ActionView::Helpers::DateHelper
    require 'twilio-ruby'
    attr_accessor :remember_token

    has_many :plants, dependent: :destroy

    # Case insensitivity for email
    before_save { self.email = email.downcase }
    # Makes sure user name is present
    validates :name, presence: true
    # Makes sure email is present and valid
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    # Ensures phone number fits correct format (+110000000000) and is unique
    validates :phone, length: { is: 10 }, format: { with: /04\d{8}/, message: "number must be a correctly formatted Victorian number (10 digits, 04...)" }, uniqueness: true
    
    # Makes sure password is present
    validates :password, presence: true
    
    # Twilio Account ID
    @@twilio_account_id = 'AC1f9a60a66869c95de7e80492d52f3dd3'
    # Twilio API id
    @@twilio_api_sid = "SKa9acd53d62bbe66526c78b7bd6105c13"
    # Twilio API secret
    @@twilio_api_secret = "soqB2yV9co4lyJoRS0UW7HQiCom8lbEP"
    # Twilio Phone number,The web app will use this number for sending messages to Users
    @@twilio_phone = "+61488856462"
    
    # Creates digest for keeping a user logged in
    # Based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-user_model_remember
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if given remember token matches decrypted remember digest
    # Based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-authenticated_p
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Removes remember digest from user
    # Based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-user_model_forget
    def forget
        update_attribute(:remember_digest, nil)
    end

    # Takes a string and returns its digest
    # Based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-digest_method
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Generates a new token for user
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Generates a user name with styled <span> tags if user is admin
    def get_styled_name
        if (admin)
            name_span = "<span class=\"admin\">" << name << "</span>"
        else
            name_span = name
        end
        name_span.html_safe
    end

    # Generates a user name with styled <span> tags if user is admin
    def get_styled_class
        if (admin)
            "admin"
        end
    end

    # Returns last time active in words (e.g. 1 minute ago) or "Never" if there is no last_active
    def last_active_in_words_or_never
        last_active
        if !last_active.nil?
            time_ago_in_words(last_active) << " ago"
        else "Never"
        end
    end

    def notify(body)
        begin
            # Makes a client with above values
            if @client.nil?
                @client = Twilio::REST::Client.new @@twilio_api_sid, @@twilio_api_secret, @@twilio_account_id
            end
            to = "+61" + phone # user.phone = "+04,d{8}"
            @client.messages.create({
            from: @@twilio_phone,
            to: to,
            body:body
            })
        
        rescue Twilio::REST::TwilioError  => exception
            puts exception.message
        end 
    end

    def  User.daily_notify
        @users = User.all
        @users.each do |user|
            if user && user.recieve_texts && !user.plants.empty?
                message="Plant Summary for: "+ user.name
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
                        if plant.relocated?
                            message+="Has been relocated."
                        end
                    end
                end
                user.notify(message)
                message=""
            end
        end
    end

    # This method will compare forecasted weather of next day from plants location
    # Against their outside plants paramaters, if exceeded (e.g: temp > plants max_temp) 
    # Notifies user to relocate their plant to indoors.
    def User.danger_check
        @users = User.all
        @users.each do |user|
            if user&&user.recieve_texts?&&!user.plants.empty?
                user.plants.each do |plant|
                    if plant.outside
                        forecast = plant.get_forecast
                        
                        plant_info = plant.get_plant
                        toSend = ""
                        if forecast && plant_info
                            # Max Temp
                            tempToUse = nil
                            # Use entered max_temp if avaliable
                            if plant.max_temp
                                tempToUse = plant.max_temp
                            else
                                tempToUse = plant_info["data"]["growth"]["maximum_temperature"]["deg_c"].to_d
                            end
                            if forecast["daily"][1]["temp"]["max"] && tempToUse
                                if forecast["daily"][1]["temp"]["max"].to_i>=tempToUse
                                    toSend+="The temperature tommorow might be a bit hot for your plant "+plant.name+". Consider keeping it inside if possible."
                                end
                            end
                            # Min Temp
                            tempToUse = nil
                            # Use entered min_temp if avaliable
                            if plant.min_temp
                                tempToUse = plant.min_temp
                            else
                                tempToUse = plant_info["data"]["growth"]["minimum_temperature"]["deg_c"].to_d
                            end
                            if forecast["daily"][1]["temp"]["min"] && tempToUse
                                if forecast["daily"][1]["temp"]["min"].to_i<=tempToUse
                                    toSend+="The temperature tommorow might be a bit cold for your plant "+plant.name+". Consider keeping it inside if possible."
                                end
                            end
                            # Wind speed, 14 m/s is considered alarming speeds
                            if forecast["daily"][1]["wind_speed"]
                                if forecast["daily"][1]["wind_speed"].to_i>=14
                                    toSend+="The wind tommorow will be quite windy for your plant "+plant.name+". Consider keeping it inside if possible."
                                end
                            end
                            user.notify(toSend)
                        end
                    end
                end
            end
        end
    end

    def User.reset_daily
        @users = User.all
        @users.each do |user|
            if user&&DateTime.current-7.days <= user.last_active
                user.plants.each do |plant|
                    if plant
                        plant.watered = false
                        plant.sunlight = false
                        # Opting to not reset relocated, as one might keep a plant out/in for multiple days
                        # plant.relocated = false
                        plant.save
                    end
                end
            end
        end
    end

    def User.calculate_score
        users = User.all
        users.each do |user|
            plants = user.plants
            points = 0
            plants.each do |plant|
                records = plant.plant_records
                record_count = 0
                records.order(created_at: :desc).each do |record|
                    if record.water_recorded
                        record_count+=1
                        points+=100*record_count
                    else
                        record_count=0
                    end
                end
            end
            user.points = points
            user.save
        end
    end
end