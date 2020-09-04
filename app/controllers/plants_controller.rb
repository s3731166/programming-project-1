class PlantsController < ApplicationController
  
  include SessionsHelper
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  require 'geocoder'

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
    #MAKE API CALL AND VERIFY :location = sean
    @plant.location = Geocoder.search(@plant.location).first.coordinates
    @plant.watered = false
    @plant.sunlight = false
    @plant.trimmed = false
    @plant.user = current_user

    respond_to do |format|
      if @plant.save
        format.html { redirect_to root_path, notice: 'Plant was successfully created.' }
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
        searchResults = Geocoder.search(@plant.location)
        if searchResults
          @plant.location = searchResults.first.coordinates
          @plant.save
        end
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

  def geo_results 
    results = Geocoder.search(params['string'])
    # toSend = results.first.city+", "+results.first.country
    toSend = ""
    i=0
    4.times do |i|
      if results[i] != nil
        if results[i].city!=nil
          toSend+= results[i].city+", "+results[i].country+"|"
        else
          toSend+= results[i].country+"|"
        end
      else 
        toSend+="|"
      end
     
    end
    #toSend = "{ \"city\":\""+results[0].city+"\", \"country\":\""+results[0].country+"\"}"
    render json: toSend, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant
      @plant = Plant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plant_params
      params.require(:plant).permit(:name, :location, :species, :watered, :sunlight, :trimmed)
    end
end

