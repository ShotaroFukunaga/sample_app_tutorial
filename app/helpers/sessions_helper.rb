module SessionsHelper

  # 渡されたユーザーをログイん
  def log_in(user)
    session[:user_id] = user.id
  end
  # 永続セッションとしてユーザーを記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  # 記憶トークン（cookie）に対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
# 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end
  def logged_in?
    !current_user.nil?# ! = banでnilがfalseになる、コントローラーのunlessの判定にtukau
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)#redirectを実行してもセッションは削除される、関数だから！！
  end
  # アクセスしようとしたURLを覚えておく
  def store_location#リクエストが送られたURLをsession変数の:forwarding_urlキーに格納
    session[:forwarding_url] = request.original_url if request.get?#ゲットリクエストならtrue
    #request => リクエストを送ってきたユーザのヘッダー情報や環境変数を取得
  end

end
