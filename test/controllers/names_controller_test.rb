require "test_helper"

class NamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get names_url
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
  end

  test "get female names" do
    get names_url, params: { sex: "F" }
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_includes response.body, "Olivia"
    assert_includes response.body, "Ariadne"
    refute_includes response.body, "Liam"
    refute_includes response.body, "Jermaine"
  end


  test "get male names" do
    get names_url, params: { sex: "M" }
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_includes response.body, "Liam"
    assert_includes response.body, "Jermaine"
    refute_includes response.body, "Olivia"
    refute_includes response.body, "Ariadne"
  end

  test "get female names from 2019" do
    get names_url, params: { sex: "F", year: "2019"}
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_includes response.body, "2019"
    refute_includes response.body, "2018"
  end

  test "get top 10 female names from 2019" do
    get names_url, params: { sex: "F", year: "2019", popularity: "10"}
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_includes response.body, "2019"
    refute_includes response.body, "2018"
    assert_includes response.body, "Olivia"
    refute_includes response.body, "Ariadne"
  end

  test "get year range for individual name" do
    get names_url, params: {name: "Olivia", yearStart: "2018", yearEnd: "2019"}
    assert_response :success
    assert_includes response.body, "2019"
    assert_includes response.body, "2018"
    refute_includes response.body, "2017"
    assert_includes response.body, "Olivia"
    refute_includes response.body, "Ariadne"
  end

  test "get historical data for individual name" do
    get names_url, params: {name: "Olivia", sex: "F"}
    assert_response :success
    assert_includes response.body, "2019"
    assert_includes response.body, "2018"
    assert_includes response.body, "Olivia"
    refute_includes response.body, "Jermaine"
  end

  test "get year range when only yearStart provided" do
    get names_url, params: {name: "Olivia", sex: "F", yearStart: "2018"}
    assert_response :success
    refute_includes response.body, "2019"
    assert_includes response.body, "2018"
    refute_includes response.body, "2017"
    assert_includes response.body, "Olivia"
    refute_includes response.body, "Jermaine"
  end

  test "get year range when only yearEnd provided" do
    get names_url, params: {name: "Olivia", sex: "F", yearEnd: "2017"}
    assert_response :success
    assert_includes response.body, "2017"
    refute_includes response.body, "2018"
    refute_includes response.body, "2019"
    assert_includes response.body, "Olivia"
    refute_includes response.body, "Jermaine"
  end
end
