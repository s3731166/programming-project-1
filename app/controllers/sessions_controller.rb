class SessionsController < ApplicationController
  include SessionsHelper
  skip_before_action :authenticate_user!, only: [:new, :create, :destroy]

  def new
  end

  # Creates logged-in session for user
  # Code based on Michael Hartl's Rails Tutorial, Chapter 8
  # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-login_upon_signup
  def create
    puts("Session create called")
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if !current_user
        puts("logged in")
        log_in(user)
        remember(user)
      end
      # isactive(user) where isactive is user.setActiveTime to now 

      flash[:success] = "Successfully logged in. Welcome, #{user.get_styled_name}.".html_safe
      redirect_to root_path
    else
      flash[:danger] = 'Email or password is invalid.' 
      redirect_to login_path
    end
  end
  
  # Destroys session
  # Code based on Michael Hartl's Rails Tutorial, Chapter 8
  # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-destroy_session
  def destroy
    # puts(@current_user.name)
    log_out if !current_user.nil?
  end
end
