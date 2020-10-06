require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.save
    # Need to be logged-in to access some pages

    # Need to be logged-in to access some pages
    new_user = users(:two)
    new_user.save
    post login_url, params: { utf8: "✓", 
        authenticity_token: "XSXJQcnJzH7aIE8IJ6Uw4He9xbBenOI8/3tc/K/H6FSqfb2Y0A4zWEaloR8Wmq1bbOKd4t+OvG3duGdfCQ4fUA==",    
        session: { email: users(:two).email,
          password: users(:two).password } }
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post users_url, params: { user: { email: "anewemail@email.com", name: "Jill", password: "thepassword", phone: "0413687423"} }
    end
    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    assert_changes -> { [User.find_by(id: @user.id).name, User.find_by(id: @user.id).email, User.find_by(id: @user.id).phone, User.find_by(id: @user.id).password]  } do
        patch user_url(User.find_by(id: @user.id)), params: { user: { email: "user@email.com", name: "Other user", password: "chicken", phone: "0413050441" } }
    end
    assert_redirected_to User.find_by(updated_at: DateTime.now)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
  end

    assert_redirected_to users_url
  end
end
