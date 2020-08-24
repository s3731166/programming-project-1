class SessionsController < ApplicationController
  include SessionsHelper
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end

  # Creates logged-in session for user
  # Code based on Michael Hartl's Rails Tutorial, Chapter 8
  # https://3rd-edition.railstutorial.org/book/log_in_log_out#code-login_upon_signup
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.password == params[:session][:password]
      log_in(user)
      remember(user)
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
    log_out if logged_in?
  end
end
