class User < ApplicationRecord
    attr_accessor :remember_token
    # Case insensitivity for email
    before_save { self.email = email.downcase }
    # Makes sure user name is present
    validates :name, presence: true
    # Makes sure email is present and valid
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    
    # Makes sure password is present
    validates :password, presence: true

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    # Takes a string and returns its digest
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Generates a new token for user
    def User.new_token
        SecureRandom.urlsafe_base64
    end
end
