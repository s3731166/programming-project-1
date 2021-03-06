class PlantsController < ApplicationController
  
  include SessionsHelper
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  require 'geocoder'
  require 'httparty'
 
  # Treffle ID Authentication token
  @@treffle_token = "1EuNspuzlsLWfDRrSfNIMpAUqcWNGvb3M0IQ__GxGTs"

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
    if @plant.treffleID
      # Retirve plant details
      # plantResults = HTTParty.get(
      #   'https://trefle.io/api/v1/species/'+@plant.treffleID.to_s+"?token="+@@treffle_token
      # )
      @plants_decoded = @plant.get_plant
      if @plants_decoded && @plants_decoded["data"]
        if @plants_decoded["data"]["growth"] 
          #FURTHER SIMPLIFIY FOR CODE RESUE : @plants_decoded["data"]["growth"]  = growthResponse
          @plantDescription = @plants_decoded["data"]["growth"]["description"] 
          @plantMaxTemp = @plants_decoded["data"]["growth"]["maximum_temperature"]["deg_c"]
          @plantMinTemp = @plants_decoded["data"]["growth"]["minimum_temperature"]["deg_c"]
        end
        @plantImage = @plants_decoded["data"]["image_url"]
      end
    end
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
    # Assume first result is accurate given in form location auto-fill
    @plant.location = Geocoder.search(@plant.locationName).first.coordinates
    # Handle TreffleID assigment
    results = HTTParty.get(
      'https://trefle.io/api/v1/species/search',
      query: {
        "q": @plant.species,
        "token": @@treffle_token
      }
    )
    @species_decoded = results.parsed_response
    if @species_decoded["data"][0]
      @plant.treffleID = @species_decoded["data"][0]["id"].to_i
    end
    @plant.watered = false
    @plant.sunlight = false
    @plant.relocated = false
    @plant.user = current_user
    respond_to do |format|
      if @plant.save
        message = 'Plant was successfully updated.'
        if !@plant.daily_water
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
        if plant_params[:locationName]
          searchResults = Geocoder.search(@plant.locationName)
          if searchResults.first
            @plant.location = searchResults.first.coordinates
          end
        end

        # Handle TreffleID assigment
        if plant_params[:species]
          results = HTTParty.get(
            'https://trefle.io/api/v1/species/search',
            query: {
              "q": @plant.species,
              "token": @@treffle_token
            }
          )
          species_decoded = results.parsed_response 
          if species_decoded["data"][0]
            # Assume the first result is most accurate, due to name lookup in form
            @plant.treffleID = species_decoded["data"][0]["id"].to_i
          end
        end

        if @plant.save
          message = 'Plant was successfully updated.'
          if !@plant.daily_water
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
    toSend = ""
    4.times do |i|
      if results[i] != nil
        if results[i].city!=nil && results[i].county!=nil
          toSend+= results[i].city+", "+results[i].country+"|"
        elsif results[i].country!=nil
          toSend+= results[i].country+"|"
        elsif results[i].city
          toSend+= results[i].city+"|"
        end
      else 
        toSend+="|"
      end
     
    end
    render json: toSend, status: :ok
  end

  def spec_results 
    #https://trefle.io/api/v1/species/search?q=coconut&token=YOUR_TREFLE_TOKEN
    #results = 'https://trefle.io/api/v1/species/search?q='+params['toSearch']+'&token='+treffle_token
    results = HTTParty.get(
      'https://trefle.io/api/v1/species/search',
      query: {
        "q": params['toSearch'],
        "token": @@treffle_token
      }
    )
    species_decoded = results.parsed_response  
    toSend=""
    
    if species_decoded["data"] != nil
      4.times do |i|
        if species_decoded["data"][i]
          if(species_decoded["data"][i]["common_name"]!=nil)
            toSend+=species_decoded["data"][i]["common_name"]
          elsif (species_decoded["data"][i]["scientific_name"]!=nil)
            toSend+=species_decoded["data"][i]["scientific_name"]
          end
          toSend+=','
          if species_decoded["data"][i]["image_url"]
            toSend+=species_decoded["data"][i]["image_url"]
          end
          toSend+=','
          toSend+=species_decoded["data"][i]["id"].to_s
          toSend+='|'
        end
        # end the if data
      end 
      # End THE 4 loop
    end
    # end the if species
    render json: toSend, status: :ok
  end
  
  # Method to parse data into javascript files for plant form auto-fill
  # Will lookup @plant for daily water and light required fields given those fields are nil
  # Does not garuntee fields will be filled
  def species_fill
    results = HTTParty.get(
      'https://trefle.io/api/v1/species/'+ params["id"],
    query: {
      "token": @@treffle_token
    })
    @plant_decoded = results.parsed_response
    toSend=""
    if @plant_decoded["data"]["growth"]
      if @plant_decoded["data"]["growth"]["minimum_precipitation"]["mm"] && @plant_decoded["data"]["growth"]["maximum_precipitation"]["mm"]
        # Daily average = (min+max / 2) / 365
        daily_water = (@plant_decoded["data"]["growth"]["minimum_precipitation"]["mm"] + @plant_decoded["data"]["growth"]["maximum_precipitation"]["mm"] / 2) / 365
          # Round to the nearest 50ml
          daily_water= ((daily_water.to_d/50).ceil) *50
          toSend+=(daily_water).to_s
      end
      toSend+="|"
      if @plant_decoded["data"]["growth"]["light"]
        #light is in 1/1000 notation
        light = @plant_decoded["data"]["growth"]["light"]
        toSend+=(light*2000).to_s
      end
      toSend+="|"
      if @plant_decoded["data"]["growth"]["minimum_temperature"]["deg_c"]
        toSend+= @plant_decoded["data"]["growth"]["minimum_temperature"]["deg_c"].to_s
      end
      toSend+=","
      if @plant_decoded["data"]["growth"]["maximum_temperature"]["deg_c"]
        tosend += @plant_decoded["data"]["growth"]["maximum_temperature"]["deg_c"].to_s
      end
    end
    render json: toSend, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant
      @plant = Plant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plant_params
      params.require(:plant).permit(:name, :location, :locationName, :species, :watered, :sunlight, :relocated, :daily_water, :outside, :plant_pic, :max_temp, :min_temp)
    end
  end


