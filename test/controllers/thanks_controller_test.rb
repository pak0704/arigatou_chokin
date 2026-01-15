require "test_helper"

class ThanksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com", password: "password")
    sign_in @user
  end

  test "should get new" do
    get new_thank_path
    assert_response :success
  end

  test "should create thank" do
    assert_difference("Thank.count", 1) do
      post thanks_path, params: {
        thank: {
          date: Date.today,
          from_who: "テストユーザー",
          situation: "テスト状況",
          feeling: "テスト感想"
        }
      }
    end
    assert_redirected_to root_path
  end
end