class User < ApplicationRecord
    include ActionView::Helpers::DateHelper
    attr_accessor :remember_token

    has_many :plants

    # Case insensitivity for email
    before_save { self.email = email.downcase }
    # Makes sure user name is present
    validates :name, presence: true
    # Makes sure email is present and valid
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    # Ensures phone number fits correct format (+110000000000)
    validates :phone, length: { is: 10 }, format: { with: /04\d{8}/, message: "number must be a correctly formatted Victorian number (10 digits, 04...)" }
    
    # Makes sure password is present
    validates :password, presence: true

    
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

    # Returns last time active in words (e.g. 1 minute ago) or "Never" if there is no last_active
    def last_active_in_words_or_never
        last_active
        if !last_active.nil?
            time_ago_in_words(last_active) << " ago"
        else "Never"
        end
    end

    def notify(message)
        #Notification constants
        account_sid = 'AC1f9a60a66869c95de7e80492d52f3dd3'
        auth_token = '4f1f5ec1a70f846ded523643f8ebb106'
        client = Twilio::REST::Client.new(account_sid, auth_token)
        from = '+61488856462' # Your Twilio number

        to = "+61" + phone # Your mobile phone number ------ "+" + user.phone = "+04,d{8}"
        client.messages.create({
        from: from,
        to: to,
        body: message
        })
        rescue
    end
end
