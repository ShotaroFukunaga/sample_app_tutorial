require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup infomation" do
    get signup_path
    assert_no_difference 'User.count' do  #User.countが変わらないことをテスト
      post users_path, params:{ user: { name: "",
                                        email: "user@invalid",
                                        password:              "foo",
                                        password_confirmation: "bar"} }
      end
      assert_template 'users/new'
      assert_select 'div.alert','The form contains 4 errors.'#divのクラスに対してメッセージがあるか？
      assert_select 'div.error_explanation' do #シャープだとクラスが見つけられなかった
        assert_select 'li',"Name can't be blank"
        assert_select 'li',"Email is invalid"
        assert_select 'li',"Password is too short (minimum is 6 characters)"
      end
    end

    test "valid signup infomation" do
      get signup_path
      assert_difference 'User.count', 1 do
        post users_path, params:{ user: { name: "Example user",
                                          email: "user@example.com",
                                          password:              "password",
                                          password_confirmation: "password"} }
        end
        follow_redirect!
        assert_template 'users/show'
        assert_not flash.empty?
      end
end
