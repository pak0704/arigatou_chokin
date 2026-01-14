require "test_helper"

class ThanksControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get thanks_new_url
    assert_response :success
  end

  test "should get create" do
    get thanks_create_url
    assert_response :success
  end
end
