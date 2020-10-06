require 'test_helper'

class PlantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plant = plants(:two)
    @plant.save

    
    # Need to be logged-in to access some pages
    new_user = users(:two)
    new_user.save
    post login_url, params: { utf8: "✓", 
    authenticity_token: "XSXJQcnJzH7aIE8IJ6Uw4He9xbBenOI8/3tc/K/H6FSqfb2Y0A4zWEaloR8Wmq1bbOKd4t+OvG3duGdfCQ4fUA==",    
    session: { email: users(:two).email,
      password: users(:two).password } }
  end

  test "should get index" do
    get plants_url
    assert_response :success
  end

  test "should get new" do
    get new_plant_url
    assert_response :success
  end

  test "should create plant" do
    assert_difference('Plant.count') do
      post plants_url, params: { plant: { name: @plant.name, locationName: @plant.locationName, species: @plant.species } }
    end

    assert_redirected_to root_path
  end

  test "should show plant" do
    get plant_url(@plant)
    assert_response :success
  end

  test "should get edit" do
    get edit_plant_url(@plant)
    assert_response :success
  end

  test "should update plant" do
    patch plant_url(@plant), params: { plant: { name: @plant.name } }
    assert_redirected_to root_path
  end

  test "should destroy plant" do
    assert_difference('Plant.count', -1) do
      delete plant_url(@plant)
    end
  end

  test "test weather by location" do
    patch plant_url(@plant), params: {plant:{locationName: "Sydney, Canada" } }
    assert_redirected_to root_path
  end

  # Must be done manualy, cannot make a tcp connection to trefle.io
  # test "should edit plant species" do
  #   assert_changes -> { @plant.species },  from: "Common sunflower", to: "Eucalyptus" do
  #     patch plant_url(@plant), params: {plant: {species: "Eucalyptus"} }
  #   end
  # end

  test "should edit plant name" do
    assert_changes -> { Plant.find_by(id: @plant.id).name },  from: "Bober", to: "Blue" do
      patch plant_url(Plant.find_by(id: @plant.id)), params: {plant:{name: "Blue" } }
    end
  end
  
end

