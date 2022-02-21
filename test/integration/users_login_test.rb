require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  test "login with invalid infomation" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: ""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid infomation" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password'}}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]",login_path, count: 0 #htmlのa[href]要素に入ってるパスのアドレスが表示されていないか確認
    assert_select "a[href=?]",logout_path
    assert_select "a[href=?]",user_path(@user)
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: "invalid"}}
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid infomation followed by logout" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password'}}

    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]",login_path, count: 0 #htmlのa[href]要素に入ってるパスのアドレスが表示されていないか確認
    assert_select "a[href=?]",logout_path
    assert_select "a[href=?]",user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
