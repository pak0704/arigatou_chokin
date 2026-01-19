require "test_helper"

class ThanksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", password: "password")
    @thank = @user.thanks.create!(
      date: Date.today,
      from_who: "テストユーザー",
      situation: "テスト状況"
    )
  end

  test "should get index when logged in" do
    sign_in @user
    get thanks_url
    assert_response :success
  end

  test "should redirect to login when not logged in for index" do
    get thanks_url
    assert_redirected_to new_user_session_path
  end

  test "should get new when logged in" do
    sign_in @user
    get new_thank_url
    assert_response :success
  end

  test "should create thank when logged in" do
    sign_in @user
    assert_difference("Thank.count") do
      post thanks_url, params: { thank: {
        date: Date.today,
        from_who: "友人",
        situation: "お土産をもらった"
      } }
    end
    assert_redirected_to thanks_path
  end

  test "should get show when logged in" do
    sign_in @user
    get thank_url(@thank)
    assert_response :success
  end

  test "should redirect to login when not logged in for show" do
    get thank_url(@thank)
    assert_redirected_to new_user_session_path
  end

  test "should not show other user's thank" do
    other_user = User.create!(email: "other@example.com", password: "password")
    other_thank = other_user.thanks.create!(
      date: Date.today,
      from_who: "他のユーザー",
      situation: "他のユーザーの記録"
    )

    sign_in @user
    get thank_url(other_thank)
    assert_response :not_found
  end
end
