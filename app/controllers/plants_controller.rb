class PlantsController < ApplicationController
  include SessionsHelper
  before_action :set_plant, only: [:show, :edit, :update, :destroy]

  # GET /plants
  # GET /plants.json
  def index
    if current_user.admin
      @plants = Plant.all
    else
      @plants = current_user.plants
    end

  end

  # GET /plants/1
  # GET /plants/1.json
  def show
  end

  # GET /plants/new
  # Redirect to home page with a danger message if user is not logged in
  def new
    unless logged_in?
      redirect_to root_path
      flash[:danger] = 'You must be logged in to add a plant.'
    else
      @plant = Plant.new
    end
  end

  # GET /plants/1/edit
  # Redirect to home page with a danger message if user is not logged in
  def edit
    unless logged_in?
      redirect_to root_path
      flash[:danger] = 'You must be logged in to edit a plant.'
    end
  end

  # POST /plants
  # POST /plants.json
  def create
    @plant = Plant.new(plant_params)
    @plant.user = current_user

    respond_to do |format|
      if @plant.save
        format.html { redirect_to @plant, notice: 'Plant was successfully created.' }
        format.json { render :show, status: :created, location: @plant }
      else
        format.html { render :new }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plants/1
  # PATCH/PUT /plants/1.json
  def update
    respond_to do |format|
      if @plant.update(plant_params)
        format.html { redirect_to root_path, notice: 'Plant was successfully updated.' }
        format.json { render :show, status: :ok, location: @plant }
      else
        format.html { render :edit }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plants/1
  # DELETE /plants/1.json
  # Redirect to home page with a danger message if user is not logged in, or else destroy plant
  def destroy
    unless logged_in?
      redirect_to root_path
      flash[:danger] = 'You must be logged in to destroy a plant.'
    else
      @plant.destroy
      respond_to do |format|
        format.html { redirect_to plants_url, notice: 'Plant was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant
      @plant = Plant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plant_params
      params.require(:plant).permit(:name, :location, :species, :water_level, :sun_time, :watered, :sunlight, :trimmed)
    end
end
