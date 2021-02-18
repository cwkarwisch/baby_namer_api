require "test_helper"

class NameTest < ActiveSupport::TestCase
  test "should not save name without without required fields" do
    name = Name.new
    assert_not name.save
  end
end
