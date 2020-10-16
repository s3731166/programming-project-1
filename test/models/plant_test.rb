require 'test_helper'

class PlantTest < ActiveSupport::TestCase
  test "should not save plant with only name" do
    my_plant_owner = users(:one)
    my_plant_owner.id = 1
    my_plant_owner.save
    
    assert_not plants(:one).valid?
  end

 

  test "should create plant" do
    # Need an existing user for a plant to be owned by, set id to 1
    my_plant_owner = users(:one)
    my_plant_owner.id = 1
    my_plant_owner.save
    
    assert plants(:two).valid?
  end

end
