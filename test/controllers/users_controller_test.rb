require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.first
  end

  test "should get show" do
    get user_path(@user)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @user.username, body["username"]
    assert_nil body["password_digest"]
  end

  test "should create new user" do
    username = "TestUser3"
    post '/users', params: { username: username, password: "secretpw"}
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal username, body["user"]["username"]
    assert_nil body["user"]["password_digest"]
    assert_not_empty body["token"]
  end

  test "should recieve errors when user fails to be created" do
    post '/users'
    body = JSON.parse(response.body)
    assert_response :success
    assert_not_empty body["errors"]
  end

  test "should update user's username" do
    new_username = "UpdatedUser1"
    patch user_path(@user), params: { username: new_username }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal new_username, body["username"]
    assert_nil body["password_digest"]
  end

  test "should delete user" do
    user_id = @user.id
    assert_difference("User.count", -1) do
      delete user_path(@user)
    end
  end
end
