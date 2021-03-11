require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: "TestUser1", password: "secretpw")
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "empty username should be invalid" do
    @user.username = ""
    assert_not @user.valid?
  end

  test "username should not exceed 25 characters" do
    @user.username = "c" * 26
    assert_not @user.valid?
  end

  test "username must be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "username must be unique on case-insensitive basis" do
    duplicate_user = @user.dup
    @user.save
    duplicate_user.username = duplicate_user.username.downcase
    assert_not duplicate_user.valid?
  end

  test "user without password should be invalid" do
    test_user = User.new(username: "TestUser5")
    assert_not test_user.valid?
  end

  test "password must be at least 8 characters" do
    test_user = User.new(username: "TestUser5", password: "secret")
    assert_not test_user.valid?
  end

  test "password must not be blank" do
    test_user = User.new(username: "TestUser5")
    test_user.password = "        "
    assert_not test_user.valid?
  end
end
