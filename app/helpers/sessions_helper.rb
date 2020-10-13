module SessionsHelper
    
    # Logs in a user.
    # Code based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-log_in_function
    def log_in(user)
       session[:user_id] = user.id
       update_last_active
    end
    
    # Keeps a persistent session for a user.
    # Code based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-remember_method
    def remember(user)
       user.remember
       cookies.permanent.signed[:user_id] = user.id
       cookies.permanent[:remember_token] = user.remember_token
    end

    # Returns the user currently logged in.
    # Code based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-branch_raise
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
    # Code based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-log_out_with_forget
    def forget(user)
       user.forget
       cookies.delete(:user_id)
       cookies.delete(:remember_token)
    end
 
    # Logs out the current user.
    # Code based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-log_out_with_forget
    def log_out
       puts("HIT LOG_OUT")
       update_last_active
       log_out_no_redirect
       redirect_to root_path
    end

    # Logs out the current user without redirecting.
    # Code based on Michael Hartl's Rails Tutorial, Chapter 8
    # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-log_out_with_forget
    def log_out_no_redirect
        puts("HIT LOG_OUT_NO_REDIRECT")
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end

    # Sets the date and time for the current user to now
    def update_last_active
      current_user.last_active = DateTime.now
      current_user.save
    end
 end