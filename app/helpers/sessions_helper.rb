module SessionsHelper
    
    # Logs in a user.
    def log_in(user)
       session[:user_id] = user.id
    end
    
    # Keeps a persistent session for a user.
    def remember(user)
       user.remember
       cookies.permanent.signed[:user_id] = user.id
       cookies.permanent[:remember_token] = user.remember_token
    end

    # Returns the user currently logged in.
    def current_user
       if (user_id = session[:user_id])
          @current_user ||= User.find_by(id: user_id)
       elsif (user_id = cookies.signed[:user_id])
          user = User.find_by(id: user_id)
          if user && user.authenticated?(cookies[:remember_token])
          log_in user
          @current_user = user
          end
       end
    end
 
    # Identifies if the user is logged in.
    def logged_in?
       !current_user.nil?
    end
 
    # Deletes a persistent session for a user.
    def forget(user)
       user.forget
       cookies.delete(:user_id)
       cookies.delete(:remember_token)
    end
 
    # Logs out the current user.
    def log_out
       forget(current_user)
       session.delete(:user_id)
       @current_user = nil
       redirect_to root_path
    end

    # Logs out the current user without redirecting.
    def log_out_no_redirect
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
     end
 end