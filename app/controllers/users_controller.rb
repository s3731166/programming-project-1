class UsersController < ApplicationController
  include SessionsHelper
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if !(logged_in?)
      redirect_to root_path
      flash[:danger] = 'You must be logged in to edit a user.'
    elsif !(current_user.admin || current_user == @user)
      redirect_to root_path
      if (@user.admin)
        flash[:danger] = 'You do not have the power to edit an admin.'
      else
        flash[:danger] = 'You do not have the power to edit another user.'
      end
    end
  end

  # POST /users
  # POST /users.json
  # Code based on Michael Hartl's Rails Tutorial, Chapter 7
  # https://3rd-edition.railstutorial.org/book/sign_up#code-signup_flash
  def create
    @user = User.new(user_params)

    if (@user.admin.nil?)
      @user.admin = false
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user
                      flash[:success] = 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  # Code based on Michael Hartl's Rails Tutorial, Chapter 9
  # https://3rd-edition.railstutorial.org/book/updating_and_deleting_users#code-user_update_action
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  # Code based on Michael Hartl's Rails Tutorial, Chapter 9
  # https://3rd-edition.railstutorial.org/book/updating_and_deleting_users#code-destroy_action
  def destroy
    if !(logged_in?)
      redirect_to root_path
      flash[:danger] = 'You must be logged in to destroy a user.'
    elsif !(current_user.admin || current_user == @user)
      redirect_to root_path
      if (@user.admin)
        flash[:danger] = 'You do not have the power to destroy an admin.'
      else
        flash[:danger] = 'You do not have the power to destroy another user.'
      end
    else
      if (@user == current_user)
        log_out_no_redirect
      end
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :admin)
    end
end
