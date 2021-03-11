require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.first
  end

  test "should login valid user" do
    post '/login', params: { username: @user.username,
                             password: "secretpw" }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @user.username, body["user"]["username"]
    assert_not_empty body["token"]
    assert_nil body["user"]["password_digest"]
  end

  test "should return 401 when user tries to login with wrong pw" do
    post '/login', params: { username: @user.username,
                             password: "secretpw2" }
    body = JSON.parse(response.body)
    assert_response(401)
    assert_empty body
  end

  test "should return 401 when non-existent user tries to login" do
    post '/login', params: { username: "MadeUpUser",
                             password: "secretpw" }
    body = JSON.parse(response.body)
    assert_response(401)
    assert_empty body
  end

  test "should authorize user when user has token" do
    token = JWT.encode({ user_id: @user.id }, Rails.application.secret_key_base, 'HS256')
    get '/auth', headers: { "Authorization": token }
    body = JSON.parse(response.body)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @user.username, body["username"]
    assert_nil body["password_digest"]
  end

  test "should return 401 when user doesn't have token" do
    get '/auth'
    body = JSON.parse(response.body)
    assert_response(401)
    assert_empty body
  end

  test "should return 401 when user has invalid token" do
    token = JWT.encode({ user_id: @user.id }, "madeupsecret", 'HS256')
    get '/auth', headers: { "Authorization": token }
    body = JSON.parse(response.body)
    assert_response(401)
    assert_empty body
  end
end
