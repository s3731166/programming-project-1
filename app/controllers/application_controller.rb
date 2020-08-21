class ApplicationController < ActionController::Base
    protect_from_forgery

    def update_last_active(user)
        if user is User then user.last_active = Date.today end
    end
end
