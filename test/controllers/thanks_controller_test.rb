require "test_helper"

class ThanksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(email: "test@example.com", password: "password")
    @thank = @user.thanks.create!(
      date: Date.today,
      from_who: "テストユーザー",
      situation: "テスト状況"
    )
    @thank2 = @user.thanks.create!(
      date: Date.today - 7,
      from_who: "友人",
      situation: "お土産をもらった"
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

  test "should get edit when logged in" do
    sign_in @user
    get edit_thank_url(@thank)
    assert_response :success
  end

  test "should redirect to login when not logged in for edit" do
    get edit_thank_url(@thank)
    assert_redirected_to new_user_session_path
  end

  test "should update thank when logged in" do
    sign_in @user
    patch thank_url(@thank), params: { thank: {
      from_who: "更新後の名前"
    } }
    assert_redirected_to thank_url(@thank)
    @thank.reload
    assert_equal "更新後の名前", @thank.from_who
  end

  test "should not update other user's thank" do
    other_user = User.create!(email: "other@example.com", password: "password")
    other_thank = other_user.thanks.create!(
      date: Date.today,
      from_who: "他のユーザー",
      situation: "他のユーザーの記録"
    )

    sign_in @user
    patch thank_url(other_thank), params: { thank: { from_who: "変更" } }
    assert_response :not_found
  end

  test "should destroy thank when logged in" do
    sign_in @user
    assert_difference("Thank.count", -1) do
      delete thank_url(@thank)
    end
    assert_redirected_to thanks_path
  end

  test "should not destroy other user's thank" do
    other_user = User.create!(email: "other@example.com", password: "password")
    other_thank = other_user.thanks.create!(
      date: Date.today,
      from_who: "他のユーザー",
      situation: "他のユーザーの記録"
    )

    sign_in @user
    assert_no_difference("Thank.count") do
      delete thank_url(other_thank)
    end
    assert_response :not_found
  end

  test "should search by from_date" do
    sign_in @user
    get thanks_url, params: { from_date: Date.today }
    assert_response :success
    # @thankのみが表示されることを確認
    assert_match @thank.from_who, @response.body
    assert_no_match @thank2.from_who, @response.body
  end

  test "should search by to_date" do
    sign_in @user
    get thanks_url, params: { to_date: Date.today - 7 }
    assert_response :success
    # @thank2のみが表示されることを確認
    assert_match @thank2.from_who, @response.body
    assert_no_match @thank.from_who, @response.body
  end

  test "should search by from_who" do
    sign_in @user
    get thanks_url, params: { from_who: "友人" }
    assert_response :success
    # @thank2のみが表示されることを確認
    assert_match @thank2.situation, @response.body
    assert_no_match @thank.situation, @response.body
  end

  test "should search by situation" do
    sign_in @user
    get thanks_url, params: { situation: "お土産" }
    assert_response :success
    # @thank2のみが表示されることを確認
    assert_match @thank2.situation, @response.body
    assert_no_match @thank.situation, @response.body
  end

  test "should search with multiple conditions" do
    sign_in @user
    get thanks_url, params: { from_who: "友人", situation: "お土産" }
    assert_response :success
    # @thank2のみが表示されることを確認
    assert_match @thank2.situation, @response.body
    assert_no_match @thank.situation, @response.body
  end
end
