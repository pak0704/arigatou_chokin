require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_url
    assert_response :success
  end

  test "should show description when not logged in" do
    get root_url
    assert_response :success
    assert_match "ありがとう貯金とは", @response.body
    assert_match "新規登録", @response.body
    assert_match "ログイン", @response.body
  end

  test "should show random thank when logged in and has records" do
    user = User.create!(email: "test@example.com", password: "password")
    thank = user.thanks.create!(
      date: Date.today,
      from_who: "テストユーザー",
      situation: "テスト状況"
    )

    sign_in user
    get root_url
    assert_response :success
    assert_match "今日のありがとう", @response.body
    assert_match thank.from_who, @response.body
  end

  test "should show no records message when logged in but no records" do
    user = User.create!(email: "test@example.com", password: "password")

    sign_in user
    get root_url
    assert_response :success
    assert_match "まだありがとう記録がありません", @response.body
  end

  test "should show action buttons when logged in" do
    user = User.create!(email: "test@example.com", password: "password")

    sign_in user
    get root_url
    assert_response :success
    assert_match "記録を見る", @response.body
    assert_match "新規作成", @response.body
    assert_match "ログアウト", @response.body
  end
end
