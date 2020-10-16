require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should be valid" do
    assert users(:one).valid?
  end
end
