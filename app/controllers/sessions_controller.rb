class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  # Creates user
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.password == params[:session][:password]
      log_in(user)
      remember(user)
      flash[:success] = "Successfully logged in. Welcome, #{user.name}."
      redirect_to root_path
    else
      flash[:danger] = 'Email or password is invalid.' 
      redirect_to login_path
    end
  end
  
  def destroy
    log_out if logged_in?
  end
end
