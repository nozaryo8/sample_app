module SessionsHelper
   # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
   # ユーザーのセッションを永続的にする9.8
  def remember(user)
    user.remember #/sample_app/app/models/user.rbのメソッド
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す（いる場合）9.9でコメントアウト
  # def current_user
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end
  
  
  # 記憶トークンcookieに対応するユーザーを返す9.9
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #raise　←9.33でコメントアウト       # テストがパスすれば、この部分がテストされていないことがわかる
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
   # 永続的セッションを破棄する 9.12
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする 8.33
  def log_out
    forget(current_user) #9.12
    session.delete(:user_id)
    @current_user = nil
  end

end
