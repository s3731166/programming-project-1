class ApplicationController < ActionController::Base
      protect_from_forgery
      helper_method :current_user
      before_action :authenticate_user!  
  
      
      # Logs in a user.
      # Code based on Michael Hartl's Rails Tutorial, Chapter 8
      # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-log_in_function
      def log_in(user)
            session[:user_id] = user.id
            update_last_active
      end

      def authenticate_user!
          unless current_user
            redirect_to '/signup'
          end
      end
      
      def current_user
        if session[:user_id]
          @current_user ||= User.find(session[:user_id])
        else
          @current_user = nil
        end
      end
end


