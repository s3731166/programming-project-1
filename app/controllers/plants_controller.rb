class PlantsController < ApplicationController
  
  include SessionsHelper
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  require 'geocoder'
  require 'httparty'
  
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
    @plant.location = Geocoder.search(@plant.locationName).first.coordinates
    @plant.watered = false
    @plant.sunlight = false
    @plant.trimmed = false
    @plant.user = current_user
    # Attempt to fill fields through plant lookup, on nil fields
    plant_lookup()
    
    respond_to do |format|
      if @plant.save
        message = 'Plant was successfully updated.'
        if !@plant.daily_water or !@plant.daily_light
          message+= "\n Auto-fill attempt failed, please fill unfilled fields."
        end
        format.html { redirect_to root_path, notice: message}
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
        # Handle location geocoding
        searchResults = Geocoder.search(@plant.locationName)
        if searchResults
          @plant.location = searchResults.first.coordinates
        end
        # Attempt auto-Fill water and light fields if nil
        plant_lookup()
        
        if @plant.save
          message = 'Plant was successfully updated.'
          if !@plant.daily_water or !@plant.daily_light
            message+= "\n Auto-fill attempt failed, please fill unfilled fields."
          end
          format.html { redirect_to root_path, notice: message}
          format.json { render :show, status: :ok, location: @plant }
        else
          format.html { render :edit }
          format.json { render json: @plant.errors, status: :unprocessable_entity }
        end
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

  def spec_results 
    #https://trefle.io/api/v1/species/search?q=coconut&token=YOUR_TREFLE_TOKEN
    #results = 'https://trefle.io/api/v1/species/search?q='+params['toSearch']+'&token='+auth_token
    auth_token = "1EuNspuzlsLWfDRrSfNIMpAUqcWNGvb3M0IQ__GxGTs"
    results = HTTParty.get(
      'https://trefle.io/api/v1/species/search',
      query: {
        "q": params['toSearch'],
        "token": auth_token
      }
    )
    @species_decoded = results.parsed_response  
    toSend=""
    
    if @species_decoded["data"] != nil
      4.times do |i|
        if @species_decoded["data"][i]
          if(@species_decoded["data"][i]["common_name"]!=nil)
            toSend+=@species_decoded["data"][i]["common_name"]
          elsif (@species_decoded["data"][i]["scientific_name"]!=nil)
            toSend+=@species_decoded["data"][i]["scientific_name"]
          end
          toSend+='|'
        end
        # end the if data
      end 
      # End THE 4 loop
    end
    # end the if species
    render json: toSend, status: :ok
  end
  
  # Will lookup @plant for daily water and light required fields given those fields are nil
  # Does not garuntee fields will be filled
  def plant_lookup
    auth_token = "1EuNspuzlsLWfDRrSfNIMpAUqcWNGvb3M0IQ__GxGTs"
    results = HTTParty.get(
      'https://trefle.io/api/v1/species/search',
    query: {
      "q": @plant.species,
      "token": auth_token
    })
    @species_decoded = results.parsed_response
    # Assume with specices lookup active in form,
    # that first result will be accurate enough for id attainment of correct plant
    plantId = nil
    if @species_decoded["data"][0]
      plantId = @species_decoded["data"][0]["id"]
    end
    if plantId
      # Retirve plant details
      results = HTTParty.get(
        'https://trefle.io/api/v1/plants/'+plantId.to_s+"?token="+auth_token
      )
      @species_decoded = results.parsed_response 
      
      if @species_decoded["data"]
        if @species_decoded["data"]["main_species"]["growth"]["minimum_precipitation"]["mm"] and @plant.daily_water==nil
          #Precipitation values are annual, daily_avg  = ((max + min) / 2) / 364 
          @plant.daily_water = ((@species_decoded["data"]["main_species"]["growth"]["maximum_precipitation"]["mm"] + @species_decoded["data"]["main_species"]["growth"]["minimum_precipitation"]["mm"])/2) /365                
        end
        #Light level is 1/10,000th of lux levels; I.e 8 = 80,000 lux
        if @species_decoded["data"]["main_species"]["growth"]["light"] and @plant.daily_light==nil
          @plant.daily_light =  @species_decoded["data"]["main_species"]["growth"]["light"]*10000
        end
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
      params.require(:plant).permit(:name, :location, :locationName, :species, :watered, :sunlight, :trimmed, :daily_water, :daily_light)
    end
  end


