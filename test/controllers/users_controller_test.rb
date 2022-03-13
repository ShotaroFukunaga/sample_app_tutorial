require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # ログインしていないユーザーがログイン画面にリダイレクトされるか？
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  # ログインしていないユーザーがフォームを送信しようとしてログイン画面にリダイレクトされるか？
  test "should redirect update when not logged in" do
    patch user_path(@user),params: { user: {  name: @user.name,
                                              email: @user.email  } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  # 間違ったユーザーがeditにリクエストを出した時にflashメッセージが表示されてroot画面にredirectされたか？
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  # 間違ったユーザーがupdateにリクエストを出した時にflashメッセージが表示されてroot画面にredirectされたか？
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email  } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "shuold redirect following not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect follow when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
